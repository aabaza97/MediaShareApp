import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: Endpoint
    func route(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}


class Router<EndPoint: Endpoint>: NetworkRouter {
    // MARK: - Properties
    private let authProvider: AuthProvider?
    private let session: URLSession
    private var task: URLSessionTask?
    
    
    // MARK: - Inits
    init(authProvider: AuthProvider, session: URLSession = .shared) {
        self.authProvider = authProvider
        self.session = session
    }
    
    
    // MARK: - Functions
    func route(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        if route.authProtected {
            // If the route is protected, make authenticated request
            self.performAuthenticatedRequest(route, completion: completion)
            return
        }
        
        self.performRequest(route, completion: completion)
    }
    
    /// Performs a network request with authentication
    private
    func performAuthenticatedRequest(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        self.authProvider?.getAccessToken() { [weak self] token, error in
            guard let token, error == nil else {
                completion(nil, nil, NetworkError.authenticationError)
                return
            }
            
            self?.performRequest(route, with: token, completion: completion)
        }
    }
    
    
    /// Performs a network request
    private
    func performRequest (_ route: EndPoint, with token: String? = nil, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try self.buildRequest(from: route, authenticatedWith: token)
            
             // Log the request
             NetworkLogger.log(request: request)
            
            // create a session task
            self.task = self.createSessionTask(for: request, on: route) { data, response, error in
                NetworkLogger.log(response: response as? HTTPURLResponse ?? .init())
                completion(data, response, error)
            }
            self.task?.resume()
           
        } catch {
            completion(nil, nil, error)
        }
    }
    
    /// Creates a session task for the request
    private
    func createSessionTask(for request: URLRequest, on route: EndPoint,completion: @escaping NetworkRouterCompletion) -> URLSessionTask {
        switch route.task {
        case .multipart: return self.session.uploadTask(with: request, from: request.httpBody ?? .init(), completionHandler: completion)
        default : return self.session.dataTask(with: request, completionHandler: completion)
        }
    }
    
    /// Builds the request from the route and token
    private
    func buildRequest(from route: EndPoint, authenticatedWith token: String?) throws -> URLRequest {
        var request = try self.buildRequest(from: route, with: APIManager.shared.baseURL)
        
        // If the route is protected, add the token to the header
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    /// Builds the request from the route and base URL
    private
    func buildRequest(from route: EndPoint, with baseURL: URL) throws -> URLRequest {
        // Build the request URL from the route
        let requestURL = baseURL.appendingPathComponent(route.version.rawValue).appendingPathComponent(route.path)
        var request = URLRequest(
            url: requestURL ,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        
        // Append all endpoint headers
        route.header?.forEach({ key, value in
            request.setValue(value, forHTTPHeaderField: key)
        })
        
        // TODO: Handle token authroization header here....
        
        switch route.task {
            
        case .plain:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case .withParams(urlParams: let urlParams, bodyParams: let bodyParams):
            if let urlParams {
                guard let url = request.url else { throw NetworkError.missingURL }
                if var urlComponents = URLComponents(url: url,resolvingAgainstBaseURL: false), !urlParams.isEmpty {
                    urlParams.forEach { _, value in
                        if let value = value as? String {
                            urlComponents.path.append("/\(value)")
                        }
                        
                        if let value = value as? Int {
                            urlComponents.path.append("/\(value)")
                        }
                    }
                    request.url = urlComponents.url
                }
                
                // Set the content type to json if not already set
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                }
            }
            
            if let bodyParams {
                do {
                    let jsonAsData = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                    request.httpBody = jsonAsData
                    
                    if request.value(forHTTPHeaderField: "Content-Type") == nil {
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                } catch _ {
                    throw NetworkError.encodingFailed
                }
            }
            
        case .multipart(info: let info, fileData: let fileData):
            var multipart = MultipartRequest()
            
            if let info {
                info.forEach { k, v in multipart.add(key: k, value: v) }
            }
            
            if let fileData {
                multipart.add(key: fileData.key, fileName: fileData.filename, fileMimeType: fileData.fileMimeType,fileData: fileData.fileData)
            }
            
            request.setValue(multipart.httpContentTypeHeaderValue, forHTTPHeaderField: "Content-Type")
            request.httpBody = multipart.httpBody
        }
        
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        request.httpMethod = route.httpMethod.rawValue
        return request
    }
    
    
    /// Cancels the current task
    func cancel() {
        self.task?.cancel()
    }
    
}

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: Endpoint
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: Endpoint>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 5 * 60
        do {
            var request = try self.buildRequest(from: route, with: APIManager.shared.baseURL)
            request.timeoutInterval = 5 * 60
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    
    private func buildRequest(from route: EndPoint, with baseURL: URL) throws -> URLRequest {
        let requestURL = baseURL.appendingPathComponent(route.version.rawValue).appendingPathComponent(route.path)
        var request = URLRequest(url: requestURL ,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
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
    
}

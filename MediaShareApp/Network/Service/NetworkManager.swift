import Foundation

protocol NetworkManager {
    typealias NetworkFailure = APIFailureResponse.ErorrResponse
    var router: any NetworkRouter { get }
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>
    func performRequest<T: Codable, E: Endpoint> (to endpoint: E, completion: @escaping (APISuccessResponse<T>?, APIFailureResponse?) -> Void) -> Void
}

extension NetworkManager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func performRequest<T: Codable, E: Endpoint> (to endpoint: E, completion: @escaping (APISuccessResponse<T>?, APIFailureResponse?) -> Void) -> Void {
        guard let router = self.router as? Router<E> else {
            print("Casting Error: Failed to cast polymorfic endpoint..")
            let errorResponse = APIFailureResponse(error: .init(message: "Something Went Wrong Making Reqeust"))
            completion(nil, errorResponse)
            return
        }
        
        
        router.request(endpoint) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, error == nil else {
                print("HTTP Error: \(error ?? NetworkError.encodingFailed)")
                let failure = NetworkFailure( message: "Failed to make HTTP request")
                let errorResponse = APIFailureResponse(error: failure)
                completion(nil, errorResponse)
                return
            }
            
            let networkResponse = self.handleNetworkResponse(response)
            
            switch networkResponse {
            case .success:
                guard let data else {
                    let failure = NetworkFailure( message: "No data to process")
                    let errorResponse = APIFailureResponse(error: failure)
                    completion(nil, errorResponse)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(
                        APISuccessResponse<T>.self,
                        from: data
                    )
                    completion(result,nil)
                } catch let error {
                    print("Decoding Error: \(error)")
                    let failure = NetworkFailure( message: "Failed to decode data")
                    let errorResponse = APIFailureResponse(error: failure)
                    completion(nil, errorResponse)
                }
            case .failure:
                guard let data else {
                    let failure = NetworkFailure( message: "No failure data to process")
                    let errorResponse = APIFailureResponse(error: failure)
                    completion(nil, errorResponse)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(
                        APIFailureResponse.self,
                        from: data
                    )
                    completion(nil, result)
                } catch let error {
                    print("Decoding Error: \(error)")
                    let failure = NetworkFailure( message: "Failed to decode data")
                    let errorResponse = APIFailureResponse(error: failure)
                    completion(nil, errorResponse)
                }
                
            }
            
        }
    }
}

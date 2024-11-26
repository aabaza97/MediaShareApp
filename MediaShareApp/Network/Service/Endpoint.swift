import Foundation

protocol Endpoint {
    var version: APIVersion { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: HTTPHeaders? { get }
    var params: Parameters? { get }
    var authProtected: Bool { get }
    
    var defaultHeaders: HTTPHeaders { get }
}

// MARK: - Associated Types
public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]


// MARK: - Default Values
extension Endpoint {
    var defaultHeaders: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accepts-Language": "en",
        ]
    }
    
    var params: Parameters? {
        nil
    }
    
    var authProtected: Bool {
        false
    }
}

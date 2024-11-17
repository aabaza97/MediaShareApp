import Foundation

protocol Endpoint {
    var version: APIVersion { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: HTTPHeaders? { get }
    var params: Parameters? { get }
    var authProtected: Bool { get }
}

// MARK: - Associated Types
public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]



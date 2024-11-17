import Foundation

protocol API {
    var baseURL: URL { get }
    var APIKey: String { get }
}

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}


struct APIManager: API {
    private var URLString: String
    private var key: String
    
    var baseURL: URL {
        return URLComponents(string: URLString)!.url!
    }
    
    var APIKey: String {
        return key
    }
    
    private init(URLString: String, key: String) {
        self.URLString = URLString
        self.key = key
    }
    
    public static var shared: APIManager = .init(URLString: "", key: "")
    
    @discardableResult mutating func resume(withURL baseURL: String, andKey key: String) -> Self {
        self.URLString = baseURL
        self.key = key
        return self
    }
}

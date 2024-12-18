import Foundation


/**
 An AuthProvider Protocol  to make the AuthManager more flexible extending the functionality of the NetworkManager
 */
protocol AuthProvider: NetworkManager {
    //MARK: - Alias
    typealias CompletionHandler<T: Codable> = (APISuccessResponse<T>?, APIFailureResponse?)-> Void
    
    /// A completion handler for token refresh
    typealias TokenCompletion = (String?, APIFailureResponse?) -> Void
    typealias OptionalCodable = (any Codable)?
    
    //MARK: - Properties
    /// The last time the token was refreshed
    var lastTokenRefresh: Date { get }
    
    /// The access token currently in use
    var accessToken: String { get }
    
    /// The refresh token
    var refreshToken: String { get }
    
    /// The access token time to live
    var ttl: Double { get }
    
    /// The state of the access token validity
    var hasValidToken: Bool { get }
    
    //MARK: - Functions
    
    /// Sends an email verification to the user with the given body
    func sendEmailVerification<T: Codable>(with body: OptionalCodable, completion: @escaping CompletionHandler<T>) -> Void
    
    /// Registers the user with the given body
    func register<T: Codable>(with body: OptionalCodable, completion: @escaping CompletionHandler<T>) -> Void
    
    /// Logs the user in with the given body
    func login<T: Codable>(with body: OptionalCodable, completion: @escaping CompletionHandler<T>) -> Void
    
    /// Logs the user out
    func logout<T: Codable>(completion: @escaping CompletionHandler<T>) -> Void
    
    /// Fetches the access token and refreshes it if it is expired
    func getAccessToken(completion: @escaping TokenCompletion) -> Void
    
    /// Refreshes the access token
    func refreshAccessToken(completion: @escaping TokenCompletion) -> Void
    
    /// Store the access token in the Keychain
    func saveTokens(from response: any Codable) -> Void
    
    /// Removes the access token from the Keychain
    func invalidateTokens() -> Void
}


//MARK: - Default Implementation
extension AuthProvider {
    var router: any NetworkRouter { Router<AuthEndpoints>(api: APIManager.shared, authProvider: AuthManager.shared) }
}

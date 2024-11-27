import Foundation


final class AuthManager: AuthProvider {
    // MARK: - Properties
    let ttl: Double = 3 * 60
    var lastTokenRefresh: Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "last_token_refresh"))
    var accessToken: String = UserDefaults.standard.string(forKey: "access_token") ?? ""
    
    
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: "refresh_token") ?? ""
        }
    }
    
    var hasValidToken: Bool {
        // Check if the difference between the current time and the last token refresh is greater than the ttl
        return !(Date.now.timeIntervalSince1970 - lastTokenRefresh.timeIntervalSince1970 > ttl)
    }
    
    // MARK: - Inits
    static let shared = AuthManager()
    
    private init() {}
    
    // MARK: - Functions
    func sendEmailVerification<T>(with body: OptionalCodable, completion: @escaping CompletionHandler<T>) where T : Decodable, T : Encodable {
        guard let body else {
            print("Invalid Body")
            return
        }
        
        self.performRequest(to: AuthEndpoints.sendEmailVerification(body: body), completion: completion)
    }
    
    func register<T>(with body: OptionalCodable, completion: @escaping CompletionHandler<T>) where T : Decodable, T : Encodable {
        guard let body else {
            print("Invalid Body")
            return
        }
        
        self.performRequest(to: AuthEndpoints.register(body: body)) { [weak self] (success: APISuccessResponse<T>? , failure) in
            guard let success, let data = success.data, failure == nil else {
                completion(nil, failure)
                return
            }
            
            
            self?.lastTokenRefresh = .now
            self?.saveTokens(from: data)
            completion(success, nil)
        }
    }
    
    func login<T>(with body: OptionalCodable, completion: @escaping CompletionHandler<T>) where T : Decodable, T : Encodable {
        guard let body else {
            print("Invalid Body")
            return
        }
        
        self.performRequest(to: AuthEndpoints.login(body: body)) { [weak self] (success: APISuccessResponse<T>?, failure)  in
            guard let success, let data = success.data, failure == nil else {
                print("Login Failure")
                completion(nil, failure)
                return
            }
            
            
            self?.lastTokenRefresh = .now
            self?.saveTokens(from: data)
            completion(success, nil)
        }
    }
    
    func logout<T>(completion: @escaping CompletionHandler<T>) where T : Decodable, T : Encodable {
        self.getAccessToken { [weak self] token, failure in
            guard let token, failure == nil else {
                completion(nil, failure)
                return
            }
            
            self?.performRequest(to: AuthEndpoints.logout(accessToken: token)) { (success: APISuccessResponse<T>? , failure) in
                guard let success, failure == nil else {
                    print(failure!)
                    completion(nil, failure)
                    return
                }
                
                self?.invalidateTokens()
                completion(success, nil)
            }
        }
    }
    
    func saveTokens(from response: any Codable) {
        if let data = response as? RegisterResponse {
            UserDefaults.standard.setValue(data.refresh_token, forKey: "refresh_token")
            UserDefaults.standard.setValue(data.access_token, forKey: "access_token")
            UserDefaults.standard.setValue(Date.now.timeIntervalSince1970, forKey: "last_token_refresh")
        } else if let data = response as? LoginResponse {
            UserDefaults.standard.setValue(data.refresh_token, forKey: "refresh_token")
            UserDefaults.standard.setValue(data.access_token, forKey: "access_token")
            UserDefaults.standard.setValue(Date.now.timeIntervalSince1970, forKey: "last_token_refresh")
        } else if let data = response as? RefreshAccessTokenResponse {
            UserDefaults.standard.setValue(data.access_token, forKey: "access_token")
            UserDefaults.standard.setValue(Date.now.timeIntervalSince1970, forKey: "last_token_refresh")
        }
        
    }
    
    func invalidateTokens() {
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "last_token_refresh")
    }
    
    
    func refreshAccessToken(completion: @escaping TokenCompletion) -> Void {
       self.performRequest(to: AuthEndpoints.refreshAccessToken) { [weak self] (success: APISuccessResponse<RefreshAccessTokenResponse>?, failure) in
            guard let data = success?.data, failure == nil else {
                print("failed to refresh!!!")
                print(failure!)
                completion(nil, failure)
                return
            }
            
            self?.accessToken = data.access_token
            self?.lastTokenRefresh = .now
            
            UserDefaults.standard.setValue(data.access_token, forKey: "access_token")
            UserDefaults.standard.setValue(Date.now.timeIntervalSince1970, forKey: "last_token_refresh")
            completion(data.access_token, nil)
        }
    }
    
    
    func getAccessToken(completion: @escaping TokenCompletion) {
        print(Date.now.timeIntervalSince1970 - lastTokenRefresh.timeIntervalSince1970)
        if Date.now.timeIntervalSince1970 - lastTokenRefresh.timeIntervalSince1970 > ttl {
            print("refreshing")
            refreshAccessToken(completion: completion)
        } else {
            completion(accessToken, nil)
        }
    }
}


struct RefreshAccessTokenResponse: Codable {
    let access_token: String
}


import Foundation


final class AuthManager: NetworkManager {
    // MARK: - Alias
    typealias SendVerificationEmailSuccess = APISuccessResponse<SendEmailVerificationResponse>
    typealias SendVerificationEmailCompletion = (SendVerificationEmailSuccess? ,APIFailureResponse?) -> Void
    typealias RegisterCompletion = (APISuccessResponse<RegisterResponse>?, APIFailureResponse?)-> Void
    typealias LoginCompletion = (APISuccessResponse<LoginResponse>?, APIFailureResponse?) -> Void
    typealias LogoutCompletion = (APISuccessResponse<LogoutResponse>?, APIFailureResponse?) -> Void
    typealias TokenCompletion = (String?, APIFailureResponse?) -> Void
    
    // MARK: - Properties
    var router: any NetworkRouter { Router<AuthEndpoints>() }
    
    let ttl: Double = 3 * 60
    private var lastTokenRefresh: Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "last_token_refresh"))
    private var accessToken: String = UserDefaults.standard.string(forKey: "access_token") ?? ""
    
    
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: "refresh_token") ?? ""
        }
    }
    
    //MARK: - Inits
    static let shared = AuthManager()
    
    private init() {}
    
    
    //MARK: - Functions
    func sendEmailVerification(with body: SendVerificationRequestBody,completion: @escaping SendVerificationEmailCompletion) -> Void {
        self.performRequest(to: AuthEndpoints.sendEmailVerification(body: body), completion: completion)
    }
    
    func register(with body: RegisterRequestBody, completion: @escaping RegisterCompletion) -> Void {
        self.performRequest(to: AuthEndpoints.register(body: body)) { [weak self] (success: APISuccessResponse<RegisterResponse>? , failure) in
            guard let success, let data = success.data, failure == nil else {
                completion(nil, failure)
                return
            }
            
            self?.accessToken = data.access_token
            self?.lastTokenRefresh = .now
            UserDefaults.standard.setValue(data.refresh_token, forKey: "refresh_token")
            UserDefaults.standard.setValue(data.access_token, forKey: "access_token")
            UserDefaults.standard.setValue(Date.now.timeIntervalSince1970, forKey: "last_token_refresh")
//            UserModel.shared.setData(from: data)
            completion(success, nil)
        }
    }
    
    func login(with body: LoginRequestBody, completion: @escaping LoginCompletion) -> Void {
        self.performRequest(to: AuthEndpoints.login(body: body)) { [weak self] (success: APISuccessResponse<LoginResponse>?, failure)  in
            guard let success, let data = success.data, failure == nil else {
                print("Login Failure")
                completion(nil, failure)
                return
            }
            
            self?.accessToken = data.access_token
            self?.lastTokenRefresh = .now
            UserDefaults.standard.setValue(data.refresh_token, forKey: "refresh_token")
            UserDefaults.standard.setValue(data.access_token, forKey: "access_token")
            UserDefaults.standard.setValue(Date.now.timeIntervalSince1970, forKey: "last_token_refresh")
            completion(success, nil)
        }
    }
    
    func logout(completion: @escaping LogoutCompletion) -> Void {
        self.getAccessToken { [weak self] token, failure in
            guard let token, failure == nil else {
                completion(nil, failure)
                return
            }
            
            print("Got Token for logout: \(token)")
            
            self?.performRequest(to: AuthEndpoints.logout(accessToken: token)) { (success: APISuccessResponse<LogoutResponse>? , failure) in
                guard let success, failure == nil else {
                    print(failure!)
                    completion(nil, failure)
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: "refresh_token")
                UserDefaults.standard.removeObject(forKey: "access_token")
                UserDefaults.standard.removeObject(forKey: "last_token_refresh")
                completion(success, nil)
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping TokenCompletion) -> Void {
        guard let token = UserDefaults.standard.string(forKey: "refresh_token") else {
            print("No token found")
            completion(nil, APIFailureResponse(error: .init(message: "No token found")))
            return
        }
        
        self.performRequest(to: AuthEndpoints.refreshAccessToken(refreshToken: token)) { [weak self] (success: APISuccessResponse<RefreshAccessTokenResponse>?, failure) in
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

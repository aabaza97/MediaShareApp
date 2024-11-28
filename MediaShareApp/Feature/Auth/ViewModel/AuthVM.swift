import SwiftUI

class AuthVM: ObservableObject {
    @Published var fname: String = ""
    @Published var lname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var otp: [String] = Array<String>(repeating: "", count: 6)
    @Published var isLoading: Bool = false
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    private init() {}
    
    static var shared: AuthVM = .init()
    
    func login() {
        guard email.isNotEmpty, password.isNotEmpty else {
            print("login: invalid input")
            return
        }
        
        let body = LoginRequestBody(email: email, password: password)
        
        self.isLoading = true
        AuthManager.shared.login(with: body) { (success: APISuccessResponse<LoginResponse>?, failure) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
            }
            guard let data = success?.data, failure == nil else {
                print("login failed")
                return
            }
            
            // Update auth state in defaults
            DispatchQueue.main.async {
                AppUser.shared.setData(from: data)
                self.isLoggedIn = true
            }
        }
    }
    
    func verifyEmail(_ didSendVerificationEmail: @escaping (Bool) -> Void) {
        guard email.isNotEmpty, fname.isNotEmpty, lname.isNotEmpty, password.isNotEmpty else {
            print("verify email: invalid input")
            return
        }
        
        let body = SendVerificationRequestBody(email: email, password: password, first_name: fname, last_name: lname)
        
        self.isLoading = true
        AuthManager.shared.sendEmailVerification(with: body) { (success: APISuccessResponse<SendEmailVerificationResponse>?, failure) in
            
            self.isLoading = false
            guard success != nil, failure == nil else {
                print("verify email failed")
                return
            }
            
            DispatchQueue.main.async {
                didSendVerificationEmail(true)
            }
        }
    }
    
    func register() {
        guard email.isNotEmpty, otp.joined().isNotEmpty else {
            print("register: invalid input")
            return
        }
        
        let body = RegisterRequestBody(email: email, otp: otp.joined())
        
        self.isLoading = true
        AuthManager.shared.register(with: body) { (success: APISuccessResponse<RegisterResponse>?, failure) in
            self.isLoading = false
            guard let data = success?.data, failure == nil else {
                print("registration failed")
                return
            }
            
            // Update auth state in defaults
            DispatchQueue.main.async {
                AppUser.shared.setData(from: data)
                self.isLoggedIn = true
            }
        }
    }
    
    func logout() {
        self.isLoading = true
        AuthManager.shared.logout { (success: APISuccessResponse<LogoutResponse>?, failure) in
            self.isLoading = false
            guard success != nil, failure == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }
}


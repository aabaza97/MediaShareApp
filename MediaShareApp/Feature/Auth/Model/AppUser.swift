import Foundation

class AppUser: Codable {
    private(set) var id: String = "0"
    private(set) var firstname: String = "user"
    private(set) var lastname: String = "name"
    private(set) var email: String = "mail@mail.com"
    
    
    // MARK: -Inits
    private init (response: LoginResponse) {
        self.id = String(response.id)
        self.firstname = response.first_name
        self.lastname = response.last_name
        self.email = response.email
    }
    
    private init (response: RegisterResponse) {
        self.id = String(response.id)
        self.firstname = response.first_name
        self.lastname = response.last_name
        self.email = response.email
    }
    
    private init () {}
    
    
    static let shared: AppUser = AppUser()
    
    // MARK: - Functions
    func setData(from response: LoginResponse) -> Void {
        self.id = String(response.id)
        self.firstname = response.first_name
        self.lastname = response.last_name
        self.email = response.email
        self.saveToUserData()
    }
    
    func setData(from response: RegisterResponse) -> Void {
        self.id = String(response.id)
        self.firstname = response.first_name
        self.lastname = response.last_name
        self.email = response.email
        self.saveToUserData()
    }
    
    func saveToUserData() -> Void {
        UserDefaults.standard.setValue(self.id, forKey: "user_id")
        UserDefaults.standard.setValue(self.firstname, forKey: "first_name")
        UserDefaults.standard.setValue(self.lastname, forKey: "last_name")
        UserDefaults.standard.setValue(self.email, forKey: "email")
    }
    
    func loadFromDefaults() -> Void {
        guard let id = UserDefaults.standard.string(forKey: "user_id") else {
            print("No user stored")
            return
        }
        
        self.id = id
        self.firstname = UserDefaults.standard.string(forKey: "first_name")!
        self.lastname = UserDefaults.standard.string(forKey: "last_name")!
        self.email = UserDefaults.standard.string(forKey: "email")!
        
    }

}

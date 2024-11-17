import Foundation

struct LoginResponse:Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let access_token: String
    let refresh_token: String
    
    
}

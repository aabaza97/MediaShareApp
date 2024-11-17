import Foundation


struct SendVerificationRequestBody: Codable {
    let email: String
    let password: String
    let first_name: String
    let last_name: String
}

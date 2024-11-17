import Foundation

struct RegisterRequestBody: Codable {
    let email: String
    let otp: String
}

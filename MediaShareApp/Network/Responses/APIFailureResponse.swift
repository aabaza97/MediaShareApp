import Foundation

struct APIFailureResponse: Codable {
    struct ErorrResponse: Codable {
        var status: Int = 0
        let message: String
    }
    
    let error: APIFailureResponse.ErorrResponse
}

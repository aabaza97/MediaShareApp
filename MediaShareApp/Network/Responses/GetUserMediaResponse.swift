import Foundation

/// Response from the GetUserMedia API
struct GetUserMediaResponse: Codable {
    let media: [Media]

    struct Media: Codable {
        let id: Int
        let name: String
        let type: String
        let download_url: String
        let is_liked: Bool
    }
        
}

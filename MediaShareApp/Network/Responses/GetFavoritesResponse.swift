import Foundation


struct GetFavoritesResponse: Codable {
    let favorites: [Favorite]
    
    struct Favorite: Codable {
        let id: Int
        let createdAt: String
    }
    
    struct ItemFavorited: Codable {
        let id: Int
        let brand: String
    }
}

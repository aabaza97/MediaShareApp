import Foundation

struct FavoriteItemBody: Codable {
    let itemId: Int
}

enum FavoriteEndpoint {
    case favoriteItem(token: String, body: FavoriteItemBody)
    case unfavorItem(token: String, itemId: Int)
    case getFavorites(token: String)
}


extension FavoriteEndpoint: Endpoint {
    var version: APIVersion {
        .v1
    }
    
    var path: String {
        return "favorites"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .favoriteItem:
            return .post
        case .unfavorItem:
            return .delete
        case .getFavorites:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .favoriteItem( _, let body):
            return .withParams(bodyParams: body.dictionary)
        case .unfavorItem( _, let itemId):
            return .withParams(urlParams: ["itemId": itemId])
        case .getFavorites:
            return .plain
        }
    }
    
    var header: HTTPHeaders? {
        var defaults = [
            "Content-Type": "application/json",
            "Accepts-Language": "en"
        ]
        
        switch self {
        case .favoriteItem(let token, _):
            defaults["Authorization"] = "Bearer \(token)"
        case .unfavorItem(let token, _):
            defaults["Authorization"] = "Bearer \(token)"
        case .getFavorites(let token):
            defaults["Authorization"] = "Bearer \(token)"
        }
        
        return defaults
    }
    
    var params: Parameters? {
        nil
    }
    
    var authProtected: Bool {
        true
    }
    
    
}

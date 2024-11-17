import Foundation

enum LikesEndpoints {
    case likeMedia(token: String, id: Int)
    case unlikeMedia(token: String, id: Int)
}

extension LikesEndpoints: Endpoint {
    var version: APIVersion {
        .v1
    }
    
    var path: String {
       return "likes"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .likeMedia:
            return .post
        case .unlikeMedia:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .likeMedia(_, let id), .unlikeMedia(_, let id):
            return .withParams(urlParams: ["id": id], bodyParams: nil)
        }
    }
    
    var header: HTTPHeaders? {
        var defaults = [
            "Content-Type": "application/json",
            "Accepts-Language": "en",
        ]
        switch self{
        case .likeMedia(let token, _), .unlikeMedia(let token, _):
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

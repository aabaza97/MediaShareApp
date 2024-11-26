import Foundation

enum LikesEndpoints {
    case likeMedia(id: Int)
    case unlikeMedia(id: Int)
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
        case .likeMedia( let id), .unlikeMedia( let id):
            return .withParams(urlParams: ["id": id], bodyParams: nil)
        }
    }
    
    var header: HTTPHeaders? {
        return self.defaultHeaders
    }
    
    var params: Parameters? {
        nil
    }
    
    var authProtected: Bool {
        true
    }
    
    
}

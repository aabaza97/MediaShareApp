import Foundation

enum MediaEndpoints {
    case uploadImage(token: String, file: MultipartFile)
    case uploadMovie(token: String, file: MultipartFile)
    case getMedia(token: String, page: Int)
    case delete(token: String, id: Int)
}


extension MediaEndpoints: Endpoint {
    var version: APIVersion {
        .v1
    }
    
    var path: String {
        switch self {
        case .uploadImage: return "/media/images"
        case .uploadMovie: return "/media/movies"
        case .getMedia: return "/media"
        case .delete: return "/media"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .uploadImage, .uploadMovie: return .put
        case .getMedia: return .get
        case .delete: return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .uploadImage(_, let file), .uploadMovie(_, let file): return .multipart(info: nil, fileData: file)
        case .getMedia(_, let page): return .withParams(urlParams: ["page": page], bodyParams: nil)
        case .delete(_, let id): return .withParams(urlParams: ["id": id], bodyParams: nil)
        }
    }
    
    var header: HTTPHeaders? {
        var defaults = self.defaultHeaders
        switch self{
        case .uploadImage(let token, _),
                .uploadMovie(let token, _),
                .getMedia(let token, _),
                .delete(let token, _):
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

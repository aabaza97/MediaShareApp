import Foundation

enum MediaEndpoints {
    case uploadImage(file: MultipartFile)
    case uploadMovie(file: MultipartFile)
    case getMedia(page: Int)
    case delete(id: Int)
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
        case .uploadImage(let file), .uploadMovie(let file): return .multipart(info: nil, fileData: file)
        case .getMedia(let page): return .withParams(urlParams: ["page": page], bodyParams: nil)
        case .delete(let id): return .withParams(urlParams: ["id": id], bodyParams: nil)
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

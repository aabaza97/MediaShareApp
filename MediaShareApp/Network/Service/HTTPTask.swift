import Foundation

public enum HTTPTask {
    case plain
    case withParams(urlParams: Parameters? = nil, bodyParams: Parameters? = nil)
    case multipart (info: [String: String]? = nil, fileData: MultipartFile? = nil )
}

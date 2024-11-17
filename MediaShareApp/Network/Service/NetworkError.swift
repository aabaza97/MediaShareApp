import Foundation

public enum NetworkError: String, Error {
    case encodingFailed = "Failed to encode data."
    case missingURL = "URL is missing"
}

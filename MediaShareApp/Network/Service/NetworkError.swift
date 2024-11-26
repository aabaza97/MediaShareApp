import Foundation

public enum NetworkError: String, Error {
    case encodingFailed = "Failed to encode data."
    case missingURL = "URL is missing"
    case authenticationError = "You need to be authenticated first."
}

import Foundation


public struct MultipartFile {
    let key: String
    let filename: String
    let fileMimeType: String
    let fileData: Data
}

import Foundation

struct APISuccessResponse<DataStruct: Codable>: Codable {
    let status: Int
    let message: String
    let data: DataStruct?
    
}

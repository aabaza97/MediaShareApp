import Foundation
import UniformTypeIdentifiers

final class MediaManager: NetworkManager {
    //MARK: - Alias
    typealias uploadCompletion = ((APISuccessResponse<UploadResponse>? ,APIFailureResponse?) -> Void)
    
    //MARK: - Properties
    var router: any NetworkRouter { Router<MediaEndpoints>()}
    
    //MARK: - Inits
    static let shared = MediaManager()
    
    private init() {}
    
    
    //MARK: - Functions
    func upload(_ type: UTType, _ file: MultipartFile, completion: @escaping uploadCompletion) -> Void {
        AuthManager.shared.getAccessToken { [weak self] token, failure in
            guard let token, failure == nil else {
                print("Failed to acquire token.\nFailure:\(String(describing: failure))")
                completion(nil, failure)
                return
            }
            
            let endPoint: MediaEndpoints = if type == .image {
                .uploadImage(token: token, file: file)
            } else {
                .uploadMovie(token: token, file: file)
            }
            
            self?.performRequest(to: endPoint, completion: { (sucess: APISuccessResponse<UploadResponse>?, failure: APIFailureResponse?) in
                guard let sucess, failure == nil else {
                    completion(nil, failure)
                    return
                }
                
                completion(sucess, nil)
            })
        }
    }
    
    
}


struct UploadResponse: Codable {
    let download_url: String
}

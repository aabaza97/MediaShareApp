import Foundation
import UniformTypeIdentifiers

/// Manager for the Media API
final class MediaManager: NetworkManager {
    //MARK: - Alias
    typealias uploadCompletion = ((APISuccessResponse<UploadMediaResponse>? ,APIFailureResponse?) -> Void)
    typealias getMyUploadedMediaCompletion = ((APISuccessResponse<GetUserMediaResponse>?, APIFailureResponse?) -> Void)
    typealias deleteCompletion = ((APISuccessResponse<DeleteMediaResponse>?, APIFailureResponse?) -> Void)
    
    //MARK: - Properties
    var router: any NetworkRouter { Router<MediaEndpoints>(authProvider: AuthManager.shared)}
    
    //MARK: - Inits
    static let shared = MediaManager()
    
    private init() {}
    
    
    //MARK: - Functions
    /// Uploads the media to the server
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
            
            self?.performRequest(to: endPoint, completion: { (sucess: APISuccessResponse<UploadMediaResponse>?, failure: APIFailureResponse?) in
                guard let sucess, failure == nil else {
                    completion(nil, failure)
                    return
                }
                
                completion(sucess, nil)
            })
        }
    }
    
    /// Fetches the media uploaded by the user
    func getMyUploadedMedia(in page: Int = 0, completion: @escaping getMyUploadedMediaCompletion) -> Void {
        AuthManager.shared.getAccessToken { [weak self] token, failure in
            guard let token, failure == nil else {
                print("Failed to acquire token.\nFailure:\(String(describing: failure))")
                completion(nil, failure)
                return
            }
            
            let endPoint: MediaEndpoints = .getMedia(token: token, page: page)
            
            self?.performRequest(to: endPoint, completion: { (sucess: APISuccessResponse<GetUserMediaResponse>?, failure: APIFailureResponse?) in
                guard let sucess, failure == nil else {
                    completion(nil, failure)
                    return
                }
                
                completion(sucess, nil)
            })
        }
    }
    
    /// Deletes the media from the server
    func deleteMedia(_ id: Int, completion: @escaping deleteCompletion) -> Void {
        AuthManager.shared.getAccessToken { [weak self] token, failure in
            guard let token, failure == nil else {
                print("Failed to acquire token.\nFailure:\(String(describing: failure))")
                completion(nil, failure)
                return
            }
            
            let endPoint: MediaEndpoints = .delete(token: token, id: id)
            
            self?.performRequest(to: endPoint, completion: { (sucess: APISuccessResponse<DeleteMediaResponse>?, failure: APIFailureResponse?) in
                guard let sucess, failure == nil else {
                    completion(nil, failure)
                    return
                }
                
                completion(sucess, nil)
            })
        }
    }
    
}


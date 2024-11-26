import Foundation

final class LikeManager: NetworkManager {
    // MARK: - Alias
    typealias likeCompletion = ((APISuccessResponse<LikeResponse>?, APIFailureResponse?) -> Void)
    typealias unlikeCompletion = ((APISuccessResponse<EmptyResponse>?, APIFailureResponse?) -> Void)
    
    // MARK: - Properties
    var router: any NetworkRouter { Router<LikesEndpoints>(authProvider: AuthManager.shared) }
    
    
    // MARK: - Inits
    static let shared = LikeManager()
    
    private init() {}
    
    
    // MARK: - Functions
    /// Likes the media
    func like(_ mediaId: Int, completion: @escaping likeCompletion) -> Void {
        let endPoint: LikesEndpoints = .likeMedia(id: mediaId)
        
        self.performRequest(to: endPoint, completion: { (success: APISuccessResponse<LikeResponse>?, failure: APIFailureResponse?) in
            guard let success, failure == nil else {
                completion(nil, failure)
                return
            }
            
            completion(success, nil)
        })
    }
    
    /// Unlikes the media
    func unlike(_ mediaId: Int, completion: @escaping unlikeCompletion) -> Void {
        let endPoint: LikesEndpoints = .unlikeMedia(id: mediaId)
        
        self.performRequest(to: endPoint, completion: { (success: APISuccessResponse<EmptyResponse>?, failure: APIFailureResponse?) in
            guard let success, failure == nil else {
                completion(nil, failure)
                return
            }
            
            completion(success, nil)
        })
    }
    
}


struct LikeResponse: Codable {
    let user_id: Int
    let upload_id: Int
}

struct EmptyResponse: Codable {}

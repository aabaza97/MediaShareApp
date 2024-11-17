import SwiftUI


class MediaVM: ObservableObject {
    // MARK: - Properties
    @Published var selectedMediaForUpload: MediaPicker.SelectedMedia?
    @Published var userMedia: [MediaItem] = []
    
    @Published var page: Int = 0
    
    // MARK: - Inits
    private init() {}
    
    // MARK: - Shared
    static var shared: MediaVM = .init()
    
    // MARK: - Functions
    /// Uploads the selected media to the server
    func uploadMedia() {
        guard let selectedMedia = selectedMediaForUpload, let data = selectedMedia.data else {
            print("uploadMedia: invalid input\nSelectedMedia: \(String(describing: selectedMediaForUpload))")
            print("Data: \(String(describing: selectedMediaForUpload?.data))")
            return
        }
        
        print("Uploading \(selectedMedia.type)...")
        let randomId = UUID().uuidString
        let file = MultipartFile(
            key: selectedMedia.keyForUpload,
            filename: "\(randomId).\(selectedMedia.type)\(selectedMedia.ext)",
            fileMimeType: selectedMedia.type.mimeType,
            fileData: data
        )
        
        MediaManager.shared.upload(selectedMedia.type, file) { success, failure in
            guard let data = success?.data, failure == nil else {
                print("uploadMedia failed.\nFailure: \(String(describing: failure))")
                return
            }
            
            print("uploadMedia success: \(data)")
        }
    }
    
    /// Fetches the media uploaded by the user
    func getMyUploadedMedia(in page: Int = 0) -> Void {
        MediaManager.shared.getMyUploadedMedia(in: page) { success, failure in
            guard let data = success?.data, failure == nil else {
                print("getMyUploadedMedia failed.\nFailure: \(String(describing: failure))")
                return
            }
            
            DispatchQueue.main.async {
                if page == 0 {
                    self.userMedia = data.media.compactMap { MediaItem(from: $0) }
                } else {
                    self.userMedia.append(contentsOf: data.media.compactMap { MediaItem(from: $0) })
                }
            }
            
            print("getMyUploadedMedia success: \(data)")
        }
    }
    
    /// Likes the media
    func likeMedia(_ media: MediaItem) {
//        MediaManager.shared.likeMedia(media.id) { success, failure in
//            guard let data = success?.data, failure == nil else {
//                print("likeMedia failed.\nFailure: \(String(describing: failure))")
//                return
//            }
//            
//            print("likeMedia success: \(data)")
        }
    
    
    /// Unlike the media
    func unlikeMedia(_ media: MediaItem) {
//        MediaManager.shared.unlikeMedia(media.id) { success, failure in
//            guard let data = success?.data, failure == nil else {
//                print("unlikeMedia failed.\nFailure: \(String(describing: failure))")
//                return
//            }
//            
//            print("unlikeMedia success: \(data)")
//        }
    }

    /// Deletes the media
        func deleteMedia(_ media: MediaItem) {
            MediaManager.shared.deleteMedia(media.id) { success, failure in
                guard let data = success?.data, failure == nil else {
                    print("deleteMedia failed.\nFailure: \(String(describing: failure))")
                    return
                }
                
                DispatchQueue.main.async {
                    self.userMedia.removeAll { $0.id == media.id }
                }
                
                print("deleteMedia success: \(data)")
            }
        }
}

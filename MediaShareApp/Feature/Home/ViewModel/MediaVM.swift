import SwiftUI


class MediaVM: ObservableObject {
    // MARK: - Properties
    @Published var selectedMediaForUpload: MediaPicker.SelectedMedia?
    
    // MARK: - Inits
    private init() {}
    
    // MARK: - Shared
    static var shared: MediaVM = .init()
    
    // MARK: - Functions
    /// Uploads the selected media to the server
    func uploadMedia() {
        print("Uploading 1 ...")
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
    
    
}

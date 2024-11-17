import SwiftUI
import PhotosUI

/// MediaSelectable protocol
public protocol MediaSelectable: Equatable {
    /// Type of the media
    /// - Note: This will be used to determine the type of media selected
    var type: UTType { get set}
    
    /// Key to be used for uploading the media
    /// - Note: This key will be used as the key in the multipart request depending on the api
    var keyForUpload: String { get }
    
    /// Data to be uploaded
    /// - Note: Should return nil if the media is not selected
    var data: Data? { get }
}
    
/// MediaPicker
/// A media picker that allows the user to select an image or a movie based on PHPickerViewController
struct MediaPicker: UIViewControllerRepresentable {
    @Binding var selectedMedia: SelectedMedia?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MediaPicker
        
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        let selectedMedia = SelectedMedia(
                            type: .image,
                            image: image as? UIImage
                        )
                        
                        self.parent.selectedMedia = selectedMedia
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.movie.identifier) { data, _ in
                    DispatchQueue.main.async {
                        let selectedMedia = SelectedMedia(
                            type: .movie,
                            movie: data
                        )
                        
                        self.parent.selectedMedia = selectedMedia
                    }
                }
            }
        }
    }
    
    //MARK: - Associated Type
    struct SelectedMedia: MediaSelectable {
        var type: UTType
        
        var data: Data? {
            switch type {
            case .image:
                return image?.jpegData(compressionQuality: 1)
            case .movie:
                return movie
            default:
                return .init()
            }
        }
        
        var keyForUpload: String {
            switch type {
            case .image:
                return "image"
            case .movie:
                return "movie"
            default:
                return ""
            }
        }
        
        /// Extension of the media
        var ext: String {
            switch type {
            case .image:
                return ".jpeg"
            case .movie:
                return ".mp4"
            default:
                return ""
            }
        }
        
        /// Image selected
        var image: UIImage?
        
        /// Movie selected
        var movie: Data?
        
        static func == (lhs: SelectedMedia, rhs: SelectedMedia) -> Bool {
            lhs.type == rhs.type &&
            lhs.image == rhs.image &&
            lhs.movie == rhs.movie
        }
    }
}

extension UTType {
    var mimeType: String {
        switch self {
        case .image: return "image/jpeg"
        case .movie: return "video/mp4"
        default: return ""
        }
    }
}

#Preview {
    @State var media: MediaPicker.SelectedMedia?
    MediaPicker(selectedMedia: $media)
}


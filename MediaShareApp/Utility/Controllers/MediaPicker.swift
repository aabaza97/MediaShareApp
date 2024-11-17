import SwiftUI
import PhotosUI

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
                        self.parent.selectedMedia?.type = .image
                        self.parent.selectedMedia?.image = image as? UIImage
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.movie.identifier) { movie, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedMedia?.type = .movie
                        self.parent.selectedMedia?.movie = movie as? URL
                    }
                }
            }
        }
    }
    
    //MARK: - Associated Type
    struct SelectedMedia {
        var type: UTType
        var image: UIImage?
        var movie: URL?
    }
}

#Preview {
    @State var media: MediaPicker.SelectedMedia?
    MediaPicker(selectedMedia: $media)
}

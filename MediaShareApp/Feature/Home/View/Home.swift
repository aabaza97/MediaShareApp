import SwiftUI

struct Home: View {
    @State private var showPhotoPicker: Bool = false
    @State private var selectedMediaForUpload: MediaPicker.SelectedMedia?
    
    var body: some View {
        AppNavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                // Scrollview listing CardViews
                
                ScrollView {
                    LazyVStack {
                        ForEach(0..<10) { _ in
                            CardView(mediaItem: MediaItem(name: "Name", type: "Image", imageData: nil, isFavorite: false))
                        }
                    }
                }
                
            }
            .navbarWithTitleAndAction(action: .some(title: "Upload", action: {
                print("Will upload shortly...")
                self.showPhotoPicker = true
            }))
            .sheet(isPresented: $showPhotoPicker) {
                MediaPicker(selectedMedia: $selectedMediaForUpload)
            }
        }
    }
}

#Preview {
    Home()
}



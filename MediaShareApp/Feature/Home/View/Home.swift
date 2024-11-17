import SwiftUI

struct Home: View {
    @State private var showMediaPicker: Bool = false
    
    @ObservedObject private var media: MediaVM = .shared
    
    var body: some View {
        AppNavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                // Scrollview listing CardViews
                ScrollView {
                    MediaListView(media: media)
                }
                .refreshable {
                    self.media.getMyUploadedMedia()
                }
                
            }
            .navbarWithTitleAndAction(action: .some(title: "Upload", action: {
                print("Will upload shortly...")
                self.showMediaPicker = true
            }))
        }
        .sheet(isPresented: $showMediaPicker) {
            MediaPicker(selectedMedia: $media.selectedMediaForUpload)
        }
        .onChange(of: media.selectedMediaForUpload) { selectedMedia in
            guard let selectedMedia else {
                print("No media selected")
                return
            }
            
            print("Uploading \(selectedMedia)...")
            self.media.uploadMedia()
        }
        .onAppear {
            print("Home did appear")
            self.media.getMyUploadedMedia()
        }
    }
    
}

#Preview {
    Home()
}



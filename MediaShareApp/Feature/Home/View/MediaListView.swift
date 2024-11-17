import SwiftUI

struct MediaListView: View {
    @ObservedObject var media: MediaVM
    @State private var showAlert: Bool = false
    
    var body: some View {
        LazyVStack {
            if media.userMedia.isEmpty {
                Text("No media found")
            } else {
                ForEach(media.userMedia) { mediaItem in
                    CardView(mediaItem: mediaItem)
                        .onAppear {
                            // load more media before reaching the end with a buffer of 2
                            let buffer = 2
                            if media.userMedia.count > buffer &&
                                mediaItem == media.userMedia[media.userMedia.count - buffer] {
                                media.page += 1
                                media.getMyUploadedMedia(in: media.page)
                            }
                        }
                        .contextMenu {
                            Button {
                                //alert to confirm delete
                                showAlert.toggle()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .alert("Delete Media", isPresented: $showAlert) {
                            Button(role: .destructive) {
                                //delete media
                                withAnimation {
                                    media.deleteMedia(mediaItem)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button(role: .cancel) {
                                showAlert.toggle()
                            } label: {
                                Label("Cancel", systemImage: "xmark")
                            }
                            
                        } message: {
                            Text("Are you sure you want to delete this media?")
                        }

                }
            }
        }
    }
}

#Preview {
    MediaListView(media: .shared)
}

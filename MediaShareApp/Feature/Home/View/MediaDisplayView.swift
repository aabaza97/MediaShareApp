import SwiftUI
import AVKit

struct MediaDisplayView: View {
    @Binding var mediaItem: MediaItem
    
    var body: some View {
        let itemWidth = UIScreen.main.bounds.width - 20.0
        
        if mediaItem.type.lowercased() == "video", let videoURL = URL(string: mediaItem.downloadURL) {
            VideoPlayer(player: AVPlayer(url: videoURL))
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: itemWidth * 5 / 4)
                .clipped()
                .background(Color.black)
        } else {
            let image = UIImage(data: mediaItem.data ?? Data()) ?? UIImage()
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: itemWidth * 5 / 4)
                .clipped()
                .background(Color.gray)
        }
    }
}

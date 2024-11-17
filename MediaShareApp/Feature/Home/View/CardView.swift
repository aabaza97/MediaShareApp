import SwiftUI


struct CardView: View {
    @State var mediaItem: MediaItem
    @State var navigationActivator: Bool = false
    
    var body: some View {
        VStack {
            let itemWidth = UIScreen.main.bounds.width - 20.0
            let image = UIImage(data: mediaItem.data ?? .SubSequence()) ?? UIImage()
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: itemWidth * 5 / 4)
                .clipped()
                .background(Color.gray
                )
            
            FootnoteText(text: mediaItem.type.capitalized , color: .black)
            
            HStack {
                T3Text(text: mediaItem.name.capitalized, color: .black)
                
                Spacer()
                
                Image(mediaItem.isLiked ? .favHeartWhiteFill : .favHeartWhite).foregroundStyle(.black)
                    .padding([.trailing])
                    .onTapGesture {
                        let completion: (MediaItem) -> Void = { self.mediaItem = $0 }
                        //                            DispatchQueue.main.async {
                        //                                self.clothingItem.isFavorite ?
                        //                                self.clothingItem.unFavor(completion) :
                        //                                self.clothingItem.favor(completion)
                        //                            }
                    }
                Image(.shareArrowWhite ).foregroundStyle(.black)
            }
            .padding([.top], -5)
        }
        .frame(maxWidth: .infinity) // Expand the VStack to fill the width
        .padding([.leading, .trailing, .bottom])
        .redacted(reason: mediaItem.data == nil ? .placeholder : [])
        .onAppear {
            let completion: (MediaItem) -> Void = { self.mediaItem = $0 }
            self.mediaItem.loadData(completion)
        }
    }
}


#Preview {
    
    CardView(
        mediaItem: .init(id: 1, name: "Name", type: "Image", downloadURL: "", isLiked: true)
    )
}

extension UIImage {
    convenience init?(from stringURL: String) {
        guard let url = URL(string: stringURL) else {
            self.init()
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            self.init()
        }
    }
}

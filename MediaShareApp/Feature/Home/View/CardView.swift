import SwiftUI


struct CardView: View {
    @State var mediaItem: MediaItem
    @State var navigationActivator: Bool = false
     
    var body: some View {
        AppNavLink(destination: { EmptyView() }) {
            VStack {
                let itemWidth = UIScreen.main.bounds.width - 20.0
                let image = UIImage(data: mediaItem.imageData ?? .SubSequence()) ?? UIImage()
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
                    
                    Image(mediaItem.isFavorite ? .favHeartWhiteFill : .favHeartWhite).foregroundStyle(.black)
                        .padding([.trailing])
                        .onTapGesture {
//                            let completion: (ClothingItem) -> Void = {
//                                self.clothingItem = $0
//                            }
//                            
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
            .redacted(reason: mediaItem.imageData != nil ? .placeholder : [])
            .onAppear {
//                let completion: (ClothingItem) -> Void = { self.clothingItem = $0 }
//                self.clothingItem.loadFirstImageIfAvailable(completion)
            }
        }
    }
}


#Preview {
    
    CardView(mediaItem: .init(name: "Image Name", type: "Image", imageData: nil, isFavorite: false))
}


struct MediaItem: Codable {
    let name: String
    let type: String
    let imageData: Data?
    let isFavorite: Bool
}

import SwiftUI

struct TextDetail: View {
    @State var itemLabel: String
    @State var text: String = LARGE_TEXT
    
    @Binding var isRootNavigationActive: Bool
    
    var body: some View {
        ScrollView {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 5.0) {
                HStack {
                    Text("\(self.itemLabel)".capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Text("Kindly, read the following carefully")
                        .font(.headline)
                        .fontWeight(.regular)
                        .opacity(0.8)
                        
                    Spacer()
                }
                
                Spacer().frame(height: 42.0)
                
                Text(self.text)
                    .font(.body)
                
                Spacer()
                Button {
                    //TODO: Update user info later
                    self.isRootNavigationActive.toggle()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                }
                
               
            }
            .padding(.horizontal)
            .foregroundStyle(.white)
        }
        .background(Color.black.ignoresSafeArea())
    }
}


let LARGE_TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus mauris a diam maecenas sed enim. Nullam ac tortor vitae purus. Ut aliquam purus sit amet luctus venenatis lectus magna. Elementum facilisis leo vel fringilla. Tellus id interdum velit laoreet id donec ultrices tincidunt. Sed vulputate odio ut enim blandit volutpat. Faucibus in ornare quam viverra orci. Mauris augue neque gravida in fermentum. Iaculis eu non diam phasellus vestibulum lorem sed risus ultricies. Velit scelerisque in dictum non. Nisl tincidunt eget nullam non. Non diam phasellus vestibulum lorem sed risus. Adipiscing diam donec adipiscing tristique risus nec. Fames ac turpis egestas maecenas pharetra convallis posuere. Aliquam etiam erat velit scelerisque in dictum non consectetur a. Iaculis at erat pellentesque adipiscing commodo elit. Lectus sit amet est placerat in egestas erat imperdiet sed.\n Nisl nisi scelerisque eu ultrices vitae auctor eu augue. Sit amet nisl suscipit adipiscing bibendum est. Est placerat in egestas erat imperdiet sed euismod nisi porta. Turpis in eu mi bibendum neque. Diam vel quam elementum pulvinar etiam non quam lacus. Sit amet aliquam id diam maecenas ultricies. Diam donec adipiscing tristique risus nec feugiat in. Purus semper eget duis at tellus at urna condimentum. Sed id semper risus in hendrerit gravida rutrum quisque non. Aliquam eleifend mi in nulla posuere sollicitudin. Semper quis lectus nulla at volutpat. Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt tortor.\n In hac habitasse platea dictumst quisque sagittis purus sit amet. Justo laoreet sit amet cursus. Tellus pellentesque eu tincidunt tortor. At auctor urna nunc id. Metus dictum at tempor commodo ullamcorper a lacus vestibulum. Eu feugiat pretium nibh ipsum consequat nisl vel pretium. In hendrerit gravida rutrum quisque non tellus. Est ante in nibh mauris cursus. Sodales neque sodales ut etiam sit amet nisl. Ultricies mi quis hendrerit dolor magna. Sollicitudin aliquam ultrices sagittis orci a scelerisque. \n Quam pellentesque nec nam aliquam sem. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien. Vel turpis nunc eget lorem dolor sed viverra ipsum. Imperdiet nulla malesuada pellentesque elit eget. Hac habitasse platea dictumst quisque sagittis purus sit. Habitant morbi tristique senectus et. Diam quam nulla porttitor massa id neque aliquam vestibulum. Vitae ultricies leo integer malesuada. Nisi quis eleifend quam adipiscing vitae proin sagittis. Et magnis dis parturient montes nascetur ridiculus mus. Velit ut tortor pretium viverra. Duis ultricies lacus sed turpis tincidunt id aliquet. In hac habitasse platea dictumst quisque sagittis. Quam lacus suspendisse faucibus interdum. Urna duis convallis convallis tellus id interdum velit laoreet id.\nVulputate odio ut enim blandit volutpat maecenas volutpat blandit. Neque volutpat ac tincidunt vitae semper quis lectus. Donec enim diam vulputate ut pharetra sit. Sed tempus urna et pharetra pharetra. Mauris pharetra et ultrices neque ornare aenean euismod elementum. Ornare massa eget egestas purus viverra. Aliquam purus sit amet luctus venenatis. Enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra. Nisl condimentum id venenatis a. Diam maecenas ultricies mi eget mauris pharetra et ultrices. Lorem ipsum dolor sit amet consectetur adipiscing."


#Preview {
    @State var isRootNavActive: Bool = false
    TextDetail(itemLabel: "LARGE_TEXT", isRootNavigationActive: $isRootNavActive)
}

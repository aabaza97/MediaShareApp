import SwiftUI


struct ProfileMenuItem: View {
    @State var itemLabel: String
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20.0)
            HStack {
                Text("\(self.itemLabel)".capitalized)
                    .font(.body)
                Spacer()
                Image(.linkArrowWhite)
            }
            Spacer().frame(height: 20.0)
            Divider().frame(height: 0.7).background(Color.black.opacity(0.15))
        }.contentShape(Rectangle())
    }
}



#Preview {
    ProfileMenuItem(itemLabel: "Profile")
}

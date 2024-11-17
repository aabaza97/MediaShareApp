import SwiftUI


struct T3Text: View {
    var text: String = ""
    var color: UIColor = .black
    
    var body: some View {
        Text(text)
            .font(.title3)
            .fontWeight(.bold)
            .fontWidth(.standard)
            .foregroundColor(Color(uiColor: color))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    T3Text()
}

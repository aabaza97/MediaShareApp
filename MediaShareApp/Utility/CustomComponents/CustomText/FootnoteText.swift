import SwiftUI

struct FootnoteText: View {
    var text: String = ""
    var color: UIColor = .black
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundColor(Color(uiColor: color))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top], 5) // Add some top padding between the image and title
    }
}

#Preview {
    FootnoteText()
}

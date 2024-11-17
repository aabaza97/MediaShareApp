import SwiftUI

struct CaptionText: View {
    var text: String = ""
    var color: UIColor = .black
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(Color(uiColor: color))
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CaptionText()
}

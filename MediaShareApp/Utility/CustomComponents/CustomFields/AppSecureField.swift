
import SwiftUI

struct AppSecureField: View {
    @Binding var text: String
    var placeholder: String
    var textColor: Color = .black
    var placeholderColor: Color = .init(uiColor: .darkGray)
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding()
            }
            SecureField("", text: $text)
                .foregroundColor(textColor)
                .textContentType(.password)
                .padding()
        }
        .background(Color.white)
        .overlay {
            Rectangle()
                .stroke(Color.black, lineWidth: 3)
        }
        
    }
}

#Preview {
    AppTextField(text: .constant(""), placeholder: "Placeholder")
}

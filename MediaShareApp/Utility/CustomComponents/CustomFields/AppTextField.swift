import SwiftUI

struct AppTextField: View {
    @Binding var text: String
    var placeholder: String
    var textColor: Color = .black
    var placeholderColor: Color = .init(uiColor: .darkGray)
    
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType = .name
    var autoCapitalization: UITextAutocapitalizationType = .none
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding()
            }
            TextField("", text: $text)
                .autocorrectionDisabled()
                .autocapitalization(autoCapitalization)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .foregroundColor(textColor)
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

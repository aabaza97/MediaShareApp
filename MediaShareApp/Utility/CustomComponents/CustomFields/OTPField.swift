import SwiftUI


struct OTPField: UIViewRepresentable {
    @Binding var text: String
    var tag: Int
    
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        textField.delegate = context.coordinator
        textField.tag = tag
        textField.keyboardType = .numberPad
        textField.textColor = .black
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 2
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, tag: tag)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var tag: Int
        
        init(text: Binding<String>, tag: Int) {
            _text = text
            self.tag = tag
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentValue = textField.text as NSString? else { return true }
            let updatedValue = currentValue.replacingCharacters(in: range, with: string)
            text = updatedValue
            
            // Move focus to next text field if a character is entered
            if updatedValue.count == 1 {
                moveFocusToNextTextField(tag)
            } else if string.isEmpty && updatedValue.isEmpty {
                moveFocusToPreviousTextField(tag)
            }
            
            return updatedValue.count <= 1
        }
        
        private func moveFocusToNextTextField(_ currentTag: Int) {
            DispatchQueue.main.async {
                if let nextTextField = self.findNextTextField(tag: currentTag + 1) {
                    nextTextField.becomeFirstResponder()
                } else {
                    // If no next field found, resignFirstResponder to dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        
        private func moveFocusToPreviousTextField(_ currentTag: Int) {
            DispatchQueue.main.async {
                if let previousTextField = self.findNextTextField(tag: currentTag - 1) {
                    previousTextField.becomeFirstResponder()
                }
            }
        }
        
        private func findNextTextField(tag: Int) -> UITextField? {
             let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows})
                .first(where: {$0.isKeyWindow})
                
            
            return keyWindow?.viewWithTag(tag) as? UITextField
        }
    }
}



#Preview {
    @State var text: String = ""
    OTPField(text: $text, tag: 0)
}

import SwiftUI


struct AppNavbarSearchField: View {
    @Binding var text: String
    var placeholder: String = "Search here..."
    var textColor: Color = .white
    var placeholderColor: Color = .init(uiColor: .lightGray)
    
    var body: some View {
        ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .foregroundStyle( .white)
                    .placeholder(placeholder, when: text.isEmpty)
            
        }
        .padding(8.0)
        .font(.custom("Lora-Regular", size: 16.0, relativeTo: .headline))
        .italic()
        
    }
}

import SwiftUI

/// AppButton is a custom button component
/// - Parameters:
///    - text: The text to display on the button
///    - action: The action to perform when the button is tapped
///    - lineThickness: The thickness of the border line
///    - lineColor: The color of the border line
struct AppButton: View {
    let text: String
    
    var lineThickness: CGFloat = 3.0
    var lineColor: Color = .black
    var backgroundColor: Color = .white
    
    @Binding var isLoading: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.vertical, 16.0)
                        .padding(.horizontal, 32.0)
                        .background(backgroundColor)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(lineColor, lineWidth: lineThickness)
                        )
                } else {
                    Text(self.text)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding()
                        .background(backgroundColor)
                        .overlay(
                            Rectangle()
                                .stroke(
                                    lineColor,
                                    lineWidth: lineThickness
                                )
                        )
                }
            }
            .transition(
                .asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                )
            )
            .animation(.easeInOut(duration: 0.3), value: isLoading)
        }
        .foregroundStyle(lineColor)
        .padding(.vertical, 16.0)
        .disabled(isLoading)
    }
}


#Preview {
    @State var loading: Bool = false
    AppButton(text: "Create Account", isLoading: $loading) {
        print("Create Account tapped")
        loading.toggle()
    }
    .padding()
}


import SwiftUI

struct OTPView: View {

    @ObservedObject var auth: AuthVM = .shared
    @FocusState private var focusField: Int?

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                
                Image(.face)
                
                Text("Verify It's You")
                    .font(.largeTitle)
                    .padding()
                    .fontWeight(.bold)
                Text("We've sent you an OTP code to your email. \n\(AuthVM.shared.email)")
                    .padding(.vertical, 30)
                
                HStack(spacing: 10) {
                    ForEach(self.auth.otp.indices, id: \.self) { index in
                        OTPField(text: $auth.otp[index], tag: index)
                            .focused($focusField, equals: index)
                    }
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
                Spacer()
                
                
                Button(action: {
                    print(self.auth.otp)
                    self.auth.register()
                }) {
                    Text("Verify")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 3)
                        )
                }
                .padding()
            }
        }
        .onAppear {
            self.focusField = .zero
        }
    }
}

#Preview {
    OTPView()
}

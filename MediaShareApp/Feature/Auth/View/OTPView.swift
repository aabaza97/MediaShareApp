
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
                
                Spacer()
                
                AppButton(text: "Verify", isLoading: $auth.isLoading) {
                        print(self.auth.otp)
                        self.auth.register()
                }
                
            }
            .padding()
        }
        .onAppear {
            self.focusField = .zero
        }
    }
}

#Preview {
    OTPView()
}

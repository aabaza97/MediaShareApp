import SwiftUI

struct RegisterView: View {
    @ObservedObject var auth: AuthVM = .shared
    @State var isOTPActive: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image(.face)
                Spacer()
                Text("Welcome to App")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.vertical)
                
                // First name
                AppTextField(
                    text: $auth.fname,
                    placeholder: "First name",
                    textContentType: .givenName
                )
                
                // Last name
                AppTextField(
                    text: $auth.lname,
                    placeholder: "Last name",
                    textContentType: .familyName
                )
                
                // Email
                AppTextField(
                    text: $auth.email,
                    placeholder: "Email",
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
                )
                
                // Password
                AppSecureField(
                    text: $auth.password,
                    placeholder: "Password"
                )
                
                // Create Account
                AppButton(text: "Create Account", isLoading: $auth.isLoading) {
                    print("did tap create account")
                    self.auth.verifyEmail { done in
                        if done {
                            // navigate to OTP screen
                            self.isOTPActive = true
                            return
                        }
                        
                        // - TODO: display some error message here
                    }
                }
                
                // Separtor
                Image(.or)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                
                // Google
                AppButton(text: "Google", isLoading: $auth.isLoading) {
                    print("did tap google create account")
                    
                }
                
                Spacer()
            }
            .padding()
                .background {
                    AppNavLink(isActive: $isOTPActive) {
                        OTPView()
                    }

                }
        }
    }
}

#Preview {
    RegisterView()
}

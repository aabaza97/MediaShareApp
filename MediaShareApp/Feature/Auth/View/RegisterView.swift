import SwiftUI

struct RegisterView: View {
    @ObservedObject var auth: AuthVM = .shared
    @State var isOTPActive: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image(.face)
                Spacer()
                Text("Welcome to App ")
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
                
                Button {
                    print("did tap create account")
                    self.auth.verifyEmail { done in
                        if done {
                            // navigate to OTP screen
                            self.isOTPActive = true
                            return
                        }
                        
                        // display some error message here
                    }
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 3)
                        )
                }
                .foregroundStyle(.black)
                .padding(.vertical)
                
                
                Image(.or)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                
                
                Button {
                    // Action
                    print("Hello")
                } label: {
                    Text("Google")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 3)
                        )
                }.foregroundStyle(.black)
                
                
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

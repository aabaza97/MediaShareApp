import SwiftUI

struct LoginView: View {
    @ObservedObject var auth: AuthVM = .shared
    
    var body: some View {
        VStack {
            Image(.face)
            Spacer()
            Text("Welcome Back to \nApp ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.vertical)
            
            // Email
            AppTextField(
                text: $auth.email,
                placeholder: "Email",
                keyboardType: .emailAddress,
                textContentType: .emailAddress
            )
            
            // Password
            AppSecureField(text: $auth.password, placeholder: "Password")
            
            AppButton(text: "Log In", isLoading: $auth.isLoading) {
                print("did tap login")
                self.auth.login()
            }
            
            
            Image(.or)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32.0)
            
            
            AppButton(text: "Google", isLoading: $auth.isLoading) {
                print("did tap google log in")
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    LoginView()
}

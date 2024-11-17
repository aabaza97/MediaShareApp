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
            
            Button {
                print("did tap login")
                self.auth.login()
            } label: {
                Text("Log In")
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
            .padding(.vertical, 16.0)
            
            
            Image(.or)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32.0)
            
            
            Button {
                // Action
                print("did tap google")
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
        }.padding()
    }
}

#Preview {
    LoginView()
}

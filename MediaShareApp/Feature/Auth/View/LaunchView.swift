import SwiftUI

struct LaunchView: View {
    var body: some View {
        AppNavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    Image(.launchIcon)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        
                    Spacer()
                    
                    Text("File Sharing Made \nSimple")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack {
                        AppNavLink {
                            LoginView().navbarAction(.cancel)
                        } label: {
                            Text("Log in")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 3)
                                )
                        }

                        
                        AppNavLink {
                            RegisterView().navbarAction(.cancel)
                        } label: {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.blue)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 3)
                                )
                        }

                    }
                    .padding(.horizontal)
                    .foregroundStyle(Color.black)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}

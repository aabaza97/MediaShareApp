import SwiftUI


struct Profile: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @State private var selectedProfileItem: Menu = .profile
    @State private var isNavigationActive: Bool = false
    
    @State var fname: String = AppUser.shared.firstname
    @State var lname: String = AppUser.shared.lastname
    @State var email: String = AppUser.shared.email
    

    enum Menu: String, CaseIterable {
        case profile = "my profile"
        case favorites = "favorites"
        case privacy = "privacy & security"
        case abaout = "about us"
        
        var id: Self { self }
    }
    
    var body: some View {
        AppNavigationView {
            VStack (spacing: 0){
                ScrollView {
                    Color.white.ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 5.0) {
                        HStack {
                            Text("\(fname) \(lname)".capitalized)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        HStack {
                            Text(email)
                                .font(.headline)
                                .fontWeight(.regular)
                                .opacity(0.8)
                                .foregroundStyle(.black)
                                
                            Spacer()
                        }
                        
                        Spacer().frame(height: 42.0)
                        
                        Divider().frame(height: 0.7).background(Color.white.opacity(0.15))
                        
                        ForEach(Array(Menu.allCases.enumerated()), id: \.element) { id, item in
                            ProfileMenuItem(itemLabel: item.rawValue)
                                .onTapGesture {
                                    print("Tapped \(item.rawValue)")
                                    self.selectedProfileItem = item
                                    self.isNavigationActive = true
                                }
                        }
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.black)
                }
                .background(Color.white.ignoresSafeArea())
                .background(
                    AppNavLink(
                        isActive: $isNavigationActive,
                        destination: {
                            let view = switch selectedProfileItem {
                            case .profile: AnyView(ProfileDetail(menuItem: self.selectedProfileItem))
                                
                            default: AnyView(TextDetail(itemLabel: "About Us", isRootNavigationActive: $isNavigationActive))
                            }
                            view.navbarWithTitleAndAction().toolbar(.hidden, for: .tabBar)
                        })
                )
                
                HStack {
                    Button(action: {
                        AuthVM.shared.logout()
                    }) {
                        Text("Log Out").font(.subheadline)
                    }
                    
                    VStack {
                        Divider()
                            .frame(minHeight: 0.5)
                            .background(Color.white)
                    }
                    .padding([.leading, .trailing], 5.0)
                    
                    Text("Version – 1.0").opacity(0.5).font(.footnote)
                }
                .padding()
                .background(Color.white.ignoresSafeArea())
                .foregroundColor(.black)
                
            }
            .navbarWithTitleAndAction(action: .none(title: ""))
        }
    }
}


#Preview {
    return Profile()
}




import SwiftUI

struct ProfileDetail: View {
    @State var menuItem: Profile.Menu
    
    @State var fname: String = AppUser.shared.firstname
    @State var lname: String = AppUser.shared.lastname
    
    
    var body: some View {
        ScrollView {
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 5.0) {
                HStack {
                    Text("\(self.menuItem.rawValue)".capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Text("Keep your personal info fresh")
                        .font(.headline)
                        .fontWeight(.regular)
                        .opacity(0.8)
                        
                    Spacer()
                }
                
                Spacer().frame(height: 42.0)
                
                
                // First name
                AppTextField(
                    text: $fname,
                    placeholder: "First name",
                    textContentType: .givenName
                )
                
                // Last name
                AppTextField(
                    text: $lname,
                    placeholder: "Last name",
                    textContentType: .familyName
                )
                
                Spacer()
                Button {
                    //TODO: Update user info later
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .overlay {
                            Rectangle().stroke(Color.black, lineWidth: 3.0)
                        }
                }
                
               
            }
            .padding(.horizontal)
            .foregroundStyle(.black)
        }
        .background(Color.white.ignoresSafeArea())
    }
}


#Preview {
    ProfileDetail(menuItem: .profile)
}

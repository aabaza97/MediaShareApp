import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        // TabView to switch between the views
        TabView {
            // HomeView
            Home()
                .tabItem {
                    Image(.group4)
                    Text("Storage")
                }
                .tag(0)
                
            
            // ProfileView
            Profile()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(1)
            
        }.accentColor(.black)
                    
    }
}

#Preview {
    MainView()
}

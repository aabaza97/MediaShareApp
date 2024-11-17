import SwiftUI

@main
struct MediaShareAppApp: App {
    // isLoggedIn state to check if the user is logged in or not
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    init() {
        // Initialze API Client
        APIManager.shared.resume(
            withURL: "http://localhost:3000/api",
            andKey: ""
        )
        
        // Load user data if priviously logged in
        AppUser.shared.loadFromDefaults()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainView()
            } else {
                LaunchView()
            }
        }
    }
}

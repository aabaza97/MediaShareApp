import SwiftUI

struct AppNavbarContainerView<Content: View>: View {
    let content: Content
    @State private var title: String = "App"
    @State private var mainAction: AppNavbar.MainAction = .none(title: "")
    @State private var dark: Bool = false
    
    @State private  var displaysSearch: Bool = false
    @State private var searchText: String = ""
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AppNavbar(title: title, mainAction: mainAction, dark: dark)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onPreferenceChange(AppNavBarTitlePreferenceKey.self, perform: { value in
            self.title = value
        })
        .onPreferenceChange(AppNavBarActionPreferenceKey.self, perform: { value in
            self.mainAction = value
        })
        
    }
}

#Preview {
    AppNavbarContainerView {
        ZStack {
            Text("Hello from custom nav bar!!!!")
        }
        .navbarTitle("App")
        .navbarAction(.none(title: "Action"))
    }
    
}

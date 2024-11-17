import SwiftUI

struct AppNavigationView<Content: View>: View {
    let content: Content
    
    @State private var navigationPath = NavigationPath()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            AppNavbarContainerView {
                content
                    .environment(\.navigationPath, $navigationPath)
            }
        }
    }
}

#Preview {
    AppNavigationView {
        ZStack {
            Text("Hello from custom nav bar!!!!")
        }
    }
}


struct NavigationPathKey: EnvironmentKey {
    static let defaultValue: Binding<NavigationPath>? = nil
}

extension EnvironmentValues {
    var navigationPath: Binding<NavigationPath>? {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }
}

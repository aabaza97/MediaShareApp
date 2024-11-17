import SwiftUI

struct AppNavLink<Label: View, Destination: View> : View {
    let destination: Destination
    let label: Label
    
    var isActive: Binding<Bool>? = nil
    
    public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    public init(isActive: Binding<Bool>, @ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label = {EmptyView()}) {
        self.destination = destination()
        self.label = label()
        self.isActive = isActive
    }
    
    var body: some View {
        if let isActive {
            NavigationLink(value: Int.random(in: 0...10), label: {})
            .navigationDestination(isPresented: isActive) {
                AppNavbarContainerView {
                    self.destination
                }
            }
        } else {
            NavigationLink {
                AppNavbarContainerView {
                    self.destination
                }
            } label: {
                self.label
            }
        }
    }
}

#Preview {
    AppNavigationView {
        AppNavLink(destination: {Text("Hello World!")}) {
            Text("Tap Me")
        }
    }
}

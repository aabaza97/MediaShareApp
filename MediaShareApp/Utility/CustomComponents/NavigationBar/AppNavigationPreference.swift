import Foundation
import SwiftUI


struct AppNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}



struct AppNavBarActionPreferenceKey: PreferenceKey {
    static var defaultValue: AppNavbar.MainAction = .none(title: "")
    
    static func reduce(value: inout AppNavbar.MainAction, nextValue: () -> AppNavbar.MainAction) {
        value = nextValue()
    }
}


struct PathPreferenceKey: PreferenceKey {
    static var defaultValue: () -> Void = {}
    
    static func reduce(value: inout () -> Void, nextValue: () -> () -> Void) {
        value = nextValue()
    }
}

struct DarkPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}


extension View {
    func navbarTitle(_ title: String) -> some View {
        self.preference(key: AppNavBarTitlePreferenceKey.self, value: title)
    }
    
    func navbarAction(_ action: AppNavbar.MainAction) -> some View {
        self.preference(key: AppNavBarActionPreferenceKey.self, value: action)
    }
    
    func navbarWithTitleAndAction(title: String = "App", action: AppNavbar.MainAction = .done) -> some View {
        self
            .navbarTitle(title)
            .navbarAction(action)
    }
    
    func appendPath(_ path: String = "first") -> some View {
        self.preference(key: PathPreferenceKey.self, value: {
            @Environment(\.navigationPath) var navigationPath
            navigationPath?.wrappedValue.append(path)
        })
    }
    
    func dark(_ dark: Bool) -> some View {
        self.preference(key: DarkPreferenceKey.self, value: dark)
    }
}


extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil 
    }
}

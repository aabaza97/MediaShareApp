import SwiftUI

struct AppNavbar: View {
    
    @Environment(\.dismiss) var dismissAction
    @Environment(\.navigationPath) var navigationPath
  
    let title: String
    let mainAction: MainAction
    var dark: Bool = false
    
    @State private  var displaysSearch: Bool = false
    @State private var searchText: String = ""
    
    
    var body: some View {
        HStack(alignment: .center) {
            if !displaysSearch {
                Title
                ExpandedDivider
                
            } else {
               AppNavbarSearchField(text: $searchText)
                    .background(Color(uiColor: .darkGray).opacity(0.5))
            }
            
            HStack {
                MainActionButton
            }
        }
        .foregroundColor(dark ? .white : .black)
        .accentColor(dark ? .white : .black)
        .font(.headline)
        .padding()
        .background(dark ? Color.black.ignoresSafeArea(edges: .top) : Color.white.ignoresSafeArea(edges: .top) )
    }
}

extension AppNavbar {

    
    enum MainAction: Equatable {
        static func == (lhs: AppNavbar.MainAction, rhs: AppNavbar.MainAction) -> Bool {
            switch (lhs, rhs) {
            case (.none(let t1), .none(let t2)): return t1 == t2
            case (.some(let t1, _), .some(let t2, _)): return t1 == t2
            case (.done,.done),  (.cancel, .cancel),  (.popToRoot, .popToRoot): return true
            default: return false
            }
        }
        
        case none(title: String)
        case done
        case cancel
        case some(title: String ,action: () -> Void)
        case popToRoot
    }
    
    private var Title: some View {
        Text (title)
            .font(.title)
            .fontWeight(.heavy)
    }
    
    private var ExpandedDivider: some View {
        VStack {
            Divider()
                .frame(minHeight: 3)
                .background(dark ? Color.white : Color.black)
        }
        .padding([.leading, .trailing], 5.0)
    }
    
    private var MainActionButton: some View {
        let disabled: Bool
        let action: () -> Void
        let buttonText: String
        switch mainAction {
        case .done:
            buttonText = "Done".capitalized
            action = dismissAction.callAsFunction
            disabled = false
            break
        case .cancel:
            buttonText = "cancel".capitalized
            action = dismissAction.callAsFunction
            disabled = false
            break
        case .popToRoot:
            buttonText = "Done".capitalized
            action = {
                print("popping to root")
                self.navigationPath?.wrappedValue = NavigationPath()
            }
            disabled = false
            break
        case .some(let title, let act):
            buttonText = title.capitalized
            action = act
            disabled = false
            break
        case .none(let title):
            buttonText = title.capitalized
            action = {}
            disabled = true
            break
        }
        
        return Button(action: {
            action()
        }, label: {
            Text(buttonText)
                .font(.headline)
                .fontWeight(.bold)
        }).disabled(disabled)
    }
    
}


#Preview {
    VStack {
        AppNavbar(title: "Title", mainAction: .cancel)
        Spacer()
    }.background(Color.black)
}

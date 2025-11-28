import SwiftUI

struct RootView: View {
    let container: AppContainer

    var body: some View {
        LoginView(api: container.api)
    }
}

#Preview {
    RootView(container: AppContainer())
}

 

import SwiftUI

struct RootView: View {
    let container: AppContainer

    var body: some View {
        HomeView(api: container.api)
    }
}

#Preview {
    RootView(container: AppContainer())
}


import SwiftUI

struct RootView: View {
    let container: AppContainer
    @State private var isAuthenticated: Bool = false

    var body: some View {
        Group {
            if isAuthenticated {
                SuperAdminHomeView()
            } else {
                //LoginView(api: container.api, tokenStore: container.tokenStore)
                //WorkersHomeView()
                //ConsumerHomeView()
                //CityHeadHomeView()
                SuperAdminHomeView()
            }
        }
        .task {
            isAuthenticated = (try? container.tokenStore.getToken()) != nil
        }
        .environmentObject(container.themeManager)
    }
}




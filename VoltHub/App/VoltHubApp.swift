import SwiftUI

@main
struct VoltHubApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)  
        }
    }
}


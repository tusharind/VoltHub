import Foundation

final class AppContainer {
    let api: APIService
    let tokenStore: AuthTokenStore
    let themeManager: ThemeManager

    init() {
        api = DefaultAPIService(
            baseURL: URL(string: "https://api.example.com")!
        )
        tokenStore = KeychainAuthTokenStore()
        themeManager = ThemeManager()
    }
}

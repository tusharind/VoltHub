import Foundation

final class AppContainer {
    let api: APIService
    let tokenStore: AuthTokenStore
    let themeManager: ThemeManager

    init() {
        tokenStore = KeychainAuthTokenStore()
        api = DefaultAPIService(
            baseURL: URL(string: "https://api.example.com")!,
            interceptors: [
                AuthRequestInterceptor(tokenStore: tokenStore),
                LoggerInterceptor()
            ]
        )
        themeManager = ThemeManager()
    }
}

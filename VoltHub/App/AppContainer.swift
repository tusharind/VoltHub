import Foundation

final class AppContainer {
    let api: APIService

    init() {
        api = DefaultAPIService(
            baseURL: URL(string: "https://api.example.com")!
        )
    }
}

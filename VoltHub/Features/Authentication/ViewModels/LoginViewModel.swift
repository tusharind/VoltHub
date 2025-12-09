import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var state: ViewState<Void> = .idle

    private let apiService: APIService
    private let tokenStore: AuthTokenStore

    init(apiService: APIService, tokenStore: AuthTokenStore) {
        self.apiService = apiService
        self.tokenStore = tokenStore
    }

    var isFormValid: Bool {
        validateEmail(email) && validatePassword(password)
    }

    func validateEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    func login() async {
        guard isFormValid else {
            state = .failure(
                NSError(
                    domain: "",
                    code: 0,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Invalid email or password"
                    ]
                )
            )
            return
        }

        state = .loading

        let body: [String: AnyEncodable] = [
            "email": AnyEncodable(email),
            "password": AnyEncodable(password),
        ]

    let endpoint = Endpoint(path: "/login", method: .post, body: body, requiresAuth: false)

        do {
            let response: LoginResponse = try await apiService.request(endpoint)
            try tokenStore.save(token: response.token)
            state = .success(())
        } catch {
            state = .failure(error)
        }
    }
}

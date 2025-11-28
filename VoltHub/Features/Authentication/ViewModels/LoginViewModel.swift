import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var state: ViewState<Void> = .idle 

    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
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
            state = .failure(NSError(domain: "", code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"]))
            return
        }

        state = .loading

        let body: [String: AnyEncodable] = [
            "email": AnyEncodable(email),
            "password": AnyEncodable(password),
        ]

        let endpoint = Endpoint(path: "/login", method: .post, body: body)

        do {
            let _: LoginResponse = try await apiService.request(endpoint)
            state = .success(())
        } catch {
            state = .failure(error)
        }
    }
}


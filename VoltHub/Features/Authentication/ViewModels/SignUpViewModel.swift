import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false

    @Published var state: ViewState<Void> = .idle

    @Published var nameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    var isFormValid: Bool {
        validateName(fullName) && validateEmail(email)
            && validatePassword(password) && passwordsMatch && nameError == nil
            && emailError == nil && passwordError == nil
            && confirmPasswordError == nil
    }

    var passwordsMatch: Bool {
        guard !confirmPassword.isEmpty else {
            confirmPasswordError = "Please confirm your password"
            return false
        }

        guard password == confirmPassword else {
            confirmPasswordError = "Passwords do not match"
            return false
        }

        confirmPasswordError = nil
        return true
    }

    func validateName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            nameError = "Name is required"
            return false
        }

        guard trimmedName.count >= 2 else {
            nameError = "Name must be at least 2 characters"
            return false
        }

        guard trimmedName.count <= 50 else {
            nameError = "Name must not exceed 50 characters"
            return false
        }

        let namePattern = #"^[a-zA-Z\s'-]+$"#
        guard
            trimmedName.range(of: namePattern, options: .regularExpression)
                != nil
        else {
            nameError =
                "Name can only contain letters, spaces, hyphens, and apostrophes"
            return false
        }

        nameError = nil
        return true
    }

    func validateEmail(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty else {
            emailError = "Email is required"
            return false
        }

        guard trimmedEmail.count <= 254 else {
            emailError = "Email is too long"
            return false
        }

        let emailPattern = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        guard
            trimmedEmail.range(of: emailPattern, options: .regularExpression)
                != nil
        else {
            emailError = "Please enter a valid email address"
            return false
        }

        let parts = trimmedEmail.split(separator: "@")
        if parts.count == 2 {
            let localPart = parts[0]
            guard localPart.count >= 1 && localPart.count <= 64 else {
                emailError = "Email format is invalid"
                return false
            }
        }

        emailError = nil
        return true
    }

    func validatePassword(_ password: String) -> Bool {
        guard !password.isEmpty else {
            passwordError = "Password is required"
            return false
        }

        guard password.count >= 8 else {
            passwordError = "Password must be at least 8 characters"
            return false
        }

        guard password.count <= 128 else {
            passwordError = "Password must not exceed 128 characters"
            return false
        }

        let uppercasePattern = ".*[A-Z]+.*"
        guard
            password.range(of: uppercasePattern, options: .regularExpression)
                != nil
        else {
            passwordError =
                "Password must contain at least one uppercase letter"
            return false
        }

        let lowercasePattern = ".*[a-z]+.*"
        guard
            password.range(of: lowercasePattern, options: .regularExpression)
                != nil
        else {
            passwordError =
                "Password must contain at least one lowercase letter"
            return false
        }

        let digitPattern = ".*[0-9]+.*"
        guard
            password.range(of: digitPattern, options: .regularExpression) != nil
        else {
            passwordError = "Password must contain at least one number"
            return false
        }

        let specialCharPattern = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
        guard
            password.range(of: specialCharPattern, options: .regularExpression)
                != nil
        else {
            passwordError =
                "Password must contain at least one special character"
            return false
        }

        passwordError = nil
        return true
    }

    func signUp() async {
        guard isFormValid else {
            state = .failure(
                NSError(
                    domain: "",
                    code: 0,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Please fill all fields correctly"
                    ]
                )
            )
            return
        }

        state = .loading

        let body: [String: AnyEncodable] = [
            "name": AnyEncodable(fullName),
            "email": AnyEncodable(email),
            "password": AnyEncodable(password),
        ]

        let endpoint = Endpoint(path: "/signup", method: .post, body: body)

        do {
            let _: LoginResponse = try await apiService.request(endpoint)
            state = .success(())
        } catch {
            state = .failure(error)
        }
    }
}

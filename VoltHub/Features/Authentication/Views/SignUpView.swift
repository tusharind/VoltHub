import SwiftUI

struct SignUpView: View {
    private let api: APIService
    @StateObject private var viewModel: SignUpViewModel
    @State private var navigateToLogin = false
    @EnvironmentObject private var theme: ThemeManager

    private let tokenStore: AuthTokenStore
    init(api: APIService, tokenStore: AuthTokenStore) {
        self.api = api
        self.tokenStore = tokenStore
        _viewModel = StateObject(wrappedValue: SignUpViewModel(apiService: api))
    }

    var body: some View {
        Group {
            if navigateToLogin {
                LoginView(api: api, tokenStore: tokenStore)
            } else {
                VStack(spacing: 20) {
                    TextField("Full name", text: $viewModel.fullName)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    ZStack(alignment: .trailing) {
                        Group {
                            if viewModel.isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                            } else {
                                SecureField(
                                    "Password",
                                    text: $viewModel.password
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        Button(action: { viewModel.isPasswordVisible.toggle() })
                        {
                            Image(
                                systemName: viewModel.isPasswordVisible
                                    ? "eye.slash" : "eye"
                            )
                            .foregroundColor(theme.current.primary)
                            .padding(.trailing, 10)
                        }
                    }

                    ZStack(alignment: .trailing) {
                        Group {
                            if viewModel.isConfirmPasswordVisible {
                                TextField(
                                    "Confirm Password",
                                    text: $viewModel.confirmPassword
                                )
                            } else {
                                SecureField(
                                    "Confirm Password",
                                    text: $viewModel.confirmPassword
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        Button(action: {
                            viewModel.isConfirmPasswordVisible.toggle()
                        }) {
                            Image(
                                systemName: viewModel.isConfirmPasswordVisible
                                    ? "eye.slash" : "eye"
                            )
                            .foregroundColor(theme.current.primary)
                            .padding(.trailing, 10)
                        }
                    }

                    if !viewModel.passwordsMatch
                        && !viewModel.confirmPassword.isEmpty
                    {
                        Text("Passwords do not match")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    if let error = viewModel.state.error {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button(action: {
                        Task {
                            await viewModel.signUp()
                            if case .success = viewModel.state {
                                navigateToLogin = true
                            }
                        }
                    }) {
                        if viewModel.state.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Create account")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    viewModel.isFormValid
                                        ? theme.current.primary : Color.gray
                                )
                                .foregroundColor(theme.current.textOnPrimary)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(
                        !viewModel.isFormValid || viewModel.state.isLoading
                    )

                    HStack {
                        Text("Already have an account?")
                        Button("Log in") { navigateToLogin = true }
                            .foregroundColor(theme.current.primary)
                    }
                    .font(.footnote)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .animation(.default, value: navigateToLogin)
    }
}

#Preview {
    let container = AppContainer()
    return SignUpView(api: container.api, tokenStore: container.tokenStore)
}

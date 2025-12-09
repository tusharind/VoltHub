import SwiftUI

struct LoginView: View {
    private let api: APIService
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var theme: ThemeManager

    init(api: APIService, tokenStore: AuthTokenStore) {
        self.api = api
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                apiService: api,
                tokenStore: tokenStore
            )
        )
    }

    var body: some View {
        VStack(spacing: 24) {

            HStack(alignment: .firstTextBaseline) {
                Text("Welcome Back!")
                    .font(.largeTitle.bold())
                    .foregroundColor(theme.current.primary)
                Spacer()
                Menu {
                    ForEach(Theme.allCases) { th in
                        Button(action: { theme.set(th) }) {
                            HStack {
                                Text(th.rawValue.capitalized)
                                if th == theme.current {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Label(
                        theme.current.rawValue.capitalized,
                        systemImage: "paintpalette.fill"
                    )
                    .labelStyle(.titleAndIcon)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                }
                .tint(theme.current.primary)
            }

            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(8)

            ZStack(alignment: .trailing) {
                Group {
                    if viewModel.isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(8)

                Button(action: {
                    viewModel.isPasswordVisible.toggle()
                }) {
                    Image(
                        systemName: viewModel.isPasswordVisible
                            ? "eye.slash" : "eye"
                    )
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    .padding(.trailing, 10)
                }
            }

            if let error = viewModel.state.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                Task { await viewModel.login() }
            }) {
                if viewModel.state.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    let isDisabled =
                        (!viewModel.isFormValid || viewModel.state.isLoading)
                    Text("Login")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(theme.current.textOnPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            theme.current.primary.opacity(
                                isDisabled ? 0.4 : 1.0
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )
                        .shadow(
                            color: theme.current.primary.opacity(
                                isDisabled ? 0.15 : 0.3
                            ),
                            radius: isDisabled ? 4 : 8,
                            x: 0,
                            y: isDisabled ? 2 : 6
                        )
                }
            }
            .disabled(!viewModel.isFormValid || viewModel.state.isLoading)

        }
        .padding()
        .tint(theme.current.primary)
        .animation(.easeInOut, value: theme.current)
    }
}

import SwiftUI

struct LoginView: View {
    private let api: APIService
    @StateObject private var viewModel: LoginViewModel

    init(api: APIService) {
        self.api = api
        _viewModel = StateObject(wrappedValue: LoginViewModel(apiService: api))
    }

    var body: some View {
        VStack(spacing: 20) {

            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
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
                .background(Color(.systemGray6))
                .cornerRadius(8)

                Button(action: {
                    viewModel.isPasswordVisible.toggle()
                }) {
                    Image(
                        systemName: viewModel.isPasswordVisible
                            ? "eye.slash" : "eye"
                    )
                    .foregroundColor(.gray)
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
                    Text("Login")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            viewModel.isFormValid ? Color.blue : Color.gray
                        )
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(!viewModel.isFormValid || viewModel.state.isLoading)

        }
        .padding()
    }
}

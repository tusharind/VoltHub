import SwiftUI

struct HomeView: View {
    let api: APIService

    @State private var users: [User] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                List(users, id: \.id) { user in
                    Text(user.name)
                }
            }
        }
        .task {
            await loadUsers()
        }
    }

    func loadUsers() async {
        do {
            let fetchedUsers: [User] = try await api.request(
                Endpoint(path: "/users")
            )
            users = fetchedUsers
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
}


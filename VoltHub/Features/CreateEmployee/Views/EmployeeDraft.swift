import SwiftUI

struct AddEmployeeView: View {

    @StateObject private var vm: AddEmployeeViewModel

    init(currentUserRole: Role) {
        _vm = StateObject(
            wrappedValue: AddEmployeeViewModel(currentUserRole: currentUserRole)
        )
    }

    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                TextField("First name", text: $vm.draft.firstName)
                TextField("Last name", text: $vm.draft.lastName)
                TextField("Email", text: $vm.draft.email)
                    .keyboardType(.emailAddress)
                TextField("Phone number", text: $vm.draft.phone)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Role")) {
                Picker("Select Role", selection: $vm.draft.role) {
                    ForEach(vm.allowedRoles) { role in
                        Text(role.displayName).tag(role)
                    }
                }
            }

            Section(header: Text("Location")) {
                TextField(
                    "City / District / State name",
                    text: $vm.draft.locationName
                )
            }

            Section(header: Text("Address")) {
                TextField("Address", text: $vm.draft.address)
            }

            Section {
                Button(action: vm.submit) {
                    if vm.isSubmitting {
                        ProgressView()
                    } else {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .navigationTitle("Add Employee")
        .alert(
            "Success",
            isPresented: Binding(
                get: { vm.submitMessage != nil },
                set: { _ in vm.submitMessage = nil }
            )
        ) {
            Button("OK") { vm.submitMessage = nil }
        } message: {
            Text(vm.submitMessage ?? "")
        }
    }
}

struct AddEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AddEmployeeView(currentUserRole: .Admin)
            }
            .previewDisplayName("Admin")

            NavigationStack {
                AddEmployeeView(currentUserRole: .India_Head)
            }
            .previewDisplayName("India Head")

            NavigationStack {
                AddEmployeeView(currentUserRole: .State_Head)
            }
            .previewDisplayName("State Head")

            NavigationStack {
                AddEmployeeView(currentUserRole: .City_Head)
            }
            .previewDisplayName("City Head")
        }
    }
}

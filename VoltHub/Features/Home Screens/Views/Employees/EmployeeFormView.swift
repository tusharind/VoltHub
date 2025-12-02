import SwiftUI

struct EmployeeFormView: View {
    @EnvironmentObject private var theme: ThemeManager
    enum Mode { case add, edit(Employee) }
    let mode: Mode
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var role: EmployeeRole = .staff
    @State private var status: EmployeeStatus = .active

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Full name", text: $name)
                    .textFieldStyle(.roundedBorder)
                Picker("Role", selection: $role) {
                    ForEach(EmployeeRole.allCases) { r in
                        Text(r.rawValue.capitalized).tag(r)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Status", selection: $status) {
                    ForEach(EmployeeStatus.allCases) { s in
                        Text(s.rawValue.capitalized).tag(s)
                    }
                }
                .pickerStyle(.segmented)
                Spacer()
                Button(action: { isPresented = false }) {
                    Text(actionLabel)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            .padding()
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { isPresented = false } } }
            .onAppear { preload() }
        }
    }

    private var title: String {
        switch mode { case .add: return "Add Employee"; case .edit: return "Edit Employee" }
    }
    private var actionLabel: String {
        switch mode { case .add: return "Save (Static)"; case .edit: return "Save Changes (Static)" }
    }
    private func preload() {
        if case .edit(let emp) = mode { name = emp.name; role = emp.role; status = emp.status }
    }
}

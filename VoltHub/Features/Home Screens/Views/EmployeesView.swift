import SwiftUI

struct EmployeesView: View {
    @EnvironmentObject private var theme: ThemeManager

    @State private var searchText: String = ""
    @State private var selectedFilter: EmployeeFilter = .all
    @State private var showAddSheet: Bool = false
    @State private var editEmployee: Employee? = nil
    @State private var deleteConfirm: Employee? = nil

    @State private var employees: [Employee] = [
        .init(id: UUID(), name: "Alice Johnson", role: .admin, status: .active),
        .init(id: UUID(), name: "Bob Smith", role: .staff, status: .inactive),
        .init(id: UUID(), name: "Carol Lee", role: .staff, status: .active),
        .init(id: UUID(), name: "David Chen", role: .admin, status: .active),
        .init(id: UUID(), name: "Eva Martinez", role: .staff, status: .active),
    ]

    private var filteredEmployees: [Employee] {
        employees.filter { emp in
            (selectedFilter == .all
                || (selectedFilter == .admin && emp.role == .admin)
                || (selectedFilter == .staff && emp.role == .staff))
                && (searchText.isEmpty
                    || emp.name.lowercased().contains(searchText.lowercased()))
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Centered title
            Text("Employees")
                .font(.largeTitle.bold())
                .foregroundColor(theme.current.primary)
                .frame(maxWidth: .infinity, alignment: .center)

            EmployeesFilterBar(
                searchText: $searchText,
                selectedFilter: $selectedFilter
            )
            .environmentObject(theme)

            ScrollView {
                LazyVStack(spacing: 12) {
                    if filteredEmployees.isEmpty {
                        Text("No employees found")
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    } else {
                        ForEach(filteredEmployees) { emp in
                            EmployeeCard(
                                emp: emp,
                                onEdit: { editEmployee = $0 },
                                onDelete: { deleteConfirm = $0 }
                            )
                            .environmentObject(theme)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .sheet(isPresented: $showAddSheet) {
            EmployeeFormView(mode: .add, isPresented: $showAddSheet)
                .environmentObject(theme)
        }
        .sheet(item: $editEmployee) { emp in
            let binding = Binding<Bool>(
                get: { editEmployee != nil },
                set: { v in if !v { editEmployee = nil } }
            )
            EmployeeFormView(mode: .edit(emp), isPresented: binding)
                .environmentObject(theme)
        }
        .alert(item: $deleteConfirm) { emp in
            Alert(
                title: Text("Delete Employee"),
                message: Text("Static UI only."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteConfirm = nil
                },
                secondaryButton: .cancel { deleteConfirm = nil }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "person.badge.plus")
                        .imageScale(.medium)
                        .padding(6)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Add Employee")
            }
        }
    }

}

#Preview {
    let container = AppContainer()
    return NavigationStack {
        EmployeesView().environmentObject(container.themeManager)
    }
}

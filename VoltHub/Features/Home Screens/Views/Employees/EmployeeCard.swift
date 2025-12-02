import SwiftUI

struct EmployeeCard: View {
    @EnvironmentObject private var theme: ThemeManager
    let emp: Employee
    var onEdit: (Employee) -> Void
    var onDelete: (Employee) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(emp.name)
                        .font(.headline)
                    Text(emp.role.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                statusBadge(emp.status)
            }
            HStack(spacing: 16) {
                Button(action: { onEdit(emp) }) {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.bordered)
                .tint(theme.current.primary)
                Button(action: { onDelete(emp) }) {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .font(.caption)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    private func statusBadge(_ status: EmployeeStatus) -> some View {
        Text(status.rawValue.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(status == .active ? theme.current.primary.opacity(0.15) : Color.gray.opacity(0.15))
            .foregroundColor(status == .active ? theme.current.primary : .gray)
            .clipShape(Capsule())
    }
}

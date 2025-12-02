import SwiftUI

struct WorkerTaskCard: View {
    @EnvironmentObject private var theme: ThemeManager
    let task: WorkerTask
    var onView: (WorkerTask) -> Void
    var onQuickComplete: ((WorkerTask) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.headline)
                    Text(task.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                statusBadge(task.status)
            }
            if let meterId = task.meterId {
                Text("Meter ID: \(meterId)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 12) {
                Button(action: { onView(task) }) {
                    Label("View", systemImage: "eye")
                }
                .buttonStyle(.bordered)
                .tint(theme.current.primary)
                if task.status == .pending, let onQuickComplete {
                    Button(action: { onQuickComplete(task) }) {
                        Label("Quick Complete", systemImage: "checkmark.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.current.primary)
                }
            }
            .font(.caption)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    private func statusBadge(_ status: TaskStatus) -> some View {
        Text(status.rawValue.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                status == .pending
                    ? theme.current.primary.opacity(0.15)
                    : Color.green.opacity(0.15)
            )
            .foregroundColor(
                status == .pending ? theme.current.primary : .green
            )
            .clipShape(Capsule())
    }
}

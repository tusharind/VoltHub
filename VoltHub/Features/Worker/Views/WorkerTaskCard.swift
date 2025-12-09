import SwiftUI

struct WorkerTaskCard: View {
    let task: WorkerTask
    let theme: Theme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.headline)
                            .foregroundColor(
                                Color(red: 0.3, green: 0.4, blue: 0.5)
                            )
                            .lineLimit(2)

                        if let meterID = task.meterID {
                            Text("Meter: \(meterID)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    StatusBadge(status: task.status, theme: theme)
                }

                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    if let location = task.location {
                        Label(location, systemImage: "location.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: taskTypeIcon(for: task.type))
                            .font(.caption)
                        Text(task.type.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(theme.primary)
                }

                HStack {
                    Spacer()
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.primary)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundColor(theme.primary)
                }
            }
            .padding()
            .background(Color(red: 0.94, green: 0.95, blue: 0.96))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func taskTypeIcon(for type: TaskType) -> String {
        switch type {
        case .takeReading:
            return "gauge"
        case .installMeter:
            return "wrench.and.screwdriver"
        }
    }
}

struct StatusBadge: View {
    let status: TaskStatus
    let theme: Theme

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }

    private var statusColor: Color {
        switch status {
        case .pending:
            return .orange
        case .completed:
            return .green
        }
    }
}

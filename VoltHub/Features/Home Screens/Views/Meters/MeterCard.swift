import SwiftUI

struct MeterCard: View {
    @EnvironmentObject private var theme: ThemeManager
    let meter: Meter
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meter.name)
                        .font(.headline)
                    Text(meter.type.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                statusBadge
            }
            HStack(spacing: 16) {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.bordered)
                .tint(theme.current.primary)

                Button(action: onDelete) {
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

    private var statusBadge: some View {
        Text(meter.status.rawValue.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                meter.status == .active
                    ? theme.current.primary.opacity(0.15)
                    : Color.gray.opacity(0.15)
            )
            .foregroundColor(
                meter.status == .active ? theme.current.primary : .gray
            )
            .clipShape(Capsule())
    }
}

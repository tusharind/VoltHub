import SwiftUI

struct OperationCard: View {
    @EnvironmentObject private var theme: ThemeManager
    let item: OperationEntity
    var onEdit: (OperationEntity) -> Void
    var onDelete: (OperationEntity) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text("Head: \(item.head)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                levelBadge(item.kind)
            }
            HStack(spacing: 16) {
                Button(action: { onEdit(item) }) {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.bordered)
                .tint(theme.current.primary)

                Button(action: { onDelete(item) }) {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .font(.caption)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    private func levelBadge(_ kind: OperationEntity.Kind) -> some View {
        Text(kind.rawValue.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(theme.current.primary.opacity(0.15))
            .foregroundColor(theme.current.primary)
            .clipShape(Capsule())
    }
}

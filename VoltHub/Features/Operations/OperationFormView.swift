import SwiftUI

struct OperationEntityFormView: View {
    @EnvironmentObject private var theme: ThemeManager
    enum Mode {
        case add(OpsLevel)
        case edit(OperationEntity)
    }
    let mode: Mode
    @Binding var isPresented: Bool
    var onSave: (OperationEntity) -> Void

    @State private var name: String = ""
    @State private var head: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Head (Person)", text: $head)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button(action: save) {
                Text(actionLabel)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(theme.current.primary)
                    .foregroundColor(theme.current.textOnPrimary)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
            }
            .disabled(
                name.trimmingCharacters(in: .whitespaces).isEmpty
                    || head.trimmingCharacters(in: .whitespaces).isEmpty
            )
            .opacity(name.isEmpty || head.isEmpty ? 0.6 : 1)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { isPresented = false }
            }
        }
        .onAppear { preload() }
    }

    private var title: String {
        switch mode {
        case .add(let lvl):
            return "Add \(lvl.rawValue.dropLast(lvl == .states ? 1 : 0))"
        case .edit(let entity):
            return "Edit \(entity.kind.rawValue.capitalized)"
        }
    }
    private var actionLabel: String {
        switch mode {
        case .add(let lvl): return "Save \(lvl.rawValue) (Static)"
        case .edit: return "Save Changes (Static)"
        }
    }

    private func preload() {
        if case .edit(let entity) = mode {
            name = entity.title
            head = entity.head
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedHead = head.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !trimmedHead.isEmpty else { return }
        let newEntity: OperationEntity
        switch mode {
        case .add(let lvl):
            switch lvl {
            case .states:
                newEntity = .state(
                    OperationState(
                        id: UUID(),
                        name: trimmedName,
                        head: trimmedHead
                    )
                )
            case .districts:
                newEntity = .district(
                    OperationDistrict(
                        id: UUID(),
                        name: trimmedName,
                        head: trimmedHead
                    )
                )
            case .cities:
                newEntity = .city(
                    OperationCity(
                        id: UUID(),
                        name: trimmedName,
                        head: trimmedHead
                    )
                )
            }
        case .edit(let existing):
            switch existing.kind {
            case .state:
                newEntity = .state(
                    OperationState(
                        id: existing.id,
                        name: trimmedName,
                        head: trimmedHead
                    )
                )
            case .district:
                newEntity = .district(
                    OperationDistrict(
                        id: existing.id,
                        name: trimmedName,
                        head: trimmedHead
                    )
                )
            case .city:
                newEntity = .city(
                    OperationCity(
                        id: existing.id,
                        name: trimmedName,
                        head: trimmedHead
                    )
                )
            }
        }
        onSave(newEntity)
        isPresented = false
    }
}

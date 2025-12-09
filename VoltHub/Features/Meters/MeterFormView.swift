import SwiftUI

struct MeterFormView: View {
    @EnvironmentObject private var theme: ThemeManager
    enum Mode {
        case add
        case edit(Meter)
    }
    let mode: Mode
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var type: MeterType = .electric
    @State private var status: MeterStatus = .active

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                Picker("Type", selection: $type) {
                    ForEach(MeterType.allCases) { t in
                        Text(t.rawValue.capitalized).tag(t)
                    }
                }
                .pickerStyle(.menu)

                Picker("Status", selection: $status) {
                    ForEach(MeterStatus.allCases) { s in
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
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { isPresented = false }
                }
            }
            .onAppear { preload() }
        }
    }

    private var title: String {
        switch mode {
        case .add: return "Add Meter"
        case .edit: return "Edit Meter"
        }
    }
    private var actionLabel: String {
        switch mode {
        case .add: return "Save (Static)"
        case .edit: return "Save Changes (Static)"
        }
    }
    private func preload() {
        if case .edit(let meter) = mode {
            name = meter.name
            type = meter.type
            status = meter.status
        }
    }
}

import SwiftUI

struct OperationsHeader: View {
    @EnvironmentObject private var theme: ThemeManager
    @Binding var level: OpsLevel

    var body: some View {
        VStack(spacing: 12) {
            Text("Operations")
                .font(.largeTitle.bold())
                .foregroundColor(theme.current.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)

            Picker("Level", selection: $level) {
                ForEach(OpsLevel.allCases) { lvl in
                    Text(lvl.rawValue).tag(lvl)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

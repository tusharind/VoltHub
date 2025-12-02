import SwiftUI

struct MetersHeader: View {
    @EnvironmentObject private var theme: ThemeManager
    var body: some View {
        Text("Meters")
            .font(.largeTitle.bold())
            .foregroundColor(theme.current.primary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
    }
}

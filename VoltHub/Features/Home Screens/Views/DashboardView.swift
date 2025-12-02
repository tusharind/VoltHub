import Charts
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var theme: ThemeManager

    private let distribution: [CategoryValue] = [
        .init(category: "A", value: 40),
        .init(category: "B", value: 25),
        .init(category: "C", value: 20),
        .init(category: "D", value: 15),
    ]
    private let weekly: [LabeledValue] = [
        .init(label: "Mon", value: 12),
        .init(label: "Tue", value: 30),
        .init(label: "Wed", value: 18),
        .init(label: "Thu", value: 26),
        .init(label: "Fri", value: 22),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Dashboard")
                    .font(.largeTitle.bold())
                    .foregroundColor(theme.current.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Distribution")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Chart(distribution) { item in
                        SectorMark(
                            angle: .value("Value", item.value),
                            innerRadius: .ratio(0.55)
                        )
                        .cornerRadius(2)
                        .foregroundStyle(by: .value("Category", item.category))
                    }
                    .chartLegend(.visible)
                    .frame(height: 180)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Weekly Activity")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Chart(weekly) { item in
                        BarMark(
                            x: .value("Day", item.label),
                            y: .value("Count", item.value)
                        )
                        .foregroundStyle(theme.current.primary)
                        .cornerRadius(4)
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 180)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)

                Spacer(minLength: 8)
            }
            .padding()
        }
    }
}

struct CategoryValue: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

struct LabeledValue: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

#Preview {
    let container = AppContainer()
    return NavigationStack {
        DashboardView().environmentObject(container.themeManager)
    }
}

import SwiftUI

struct AreasView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var areas = Area.samples
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Search areas...", text: $searchText)
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(10)
                .padding(.horizontal)

            if filteredAreas.isEmpty {
                EmptyStateView(
                    icon: "map",
                    message: "No areas found",
                    description: "Try adjusting your search"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredAreas) { area in
                            AreaCard(area: area)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredAreas: [Area] {
        if searchText.isEmpty {
            return areas
        }
        return areas.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

struct AreaCard: View {
    let area: Area
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "map.fill")
                    .font(.title2)
                    .foregroundColor(themeManager.current.primary)

                Text(area.name)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }

            Divider()

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                AreaStat(
                    label: "Consumers",
                    value: "\(area.totalConsumers)",
                    icon: "person.3.fill"
                )

                AreaStat(
                    label: "Active Meters",
                    value: "\(area.activeMeters)",
                    icon: "gauge"
                )

                AreaStat(
                    label: "Pending Issues",
                    value: "\(area.pendingIssues)",
                    icon: "exclamationmark.triangle.fill",
                    color: area.pendingIssues > 5 ? .red : .orange
                )

                AreaStat(
                    label: "Workers",
                    value: "\(area.assignedWorkers)",
                    icon: "person.fill.checkmark"
                )
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct AreaStat: View {
    let label: String
    let value: String
    let icon: String
    var color: Color = .secondary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AreasView()
        .environmentObject(ThemeManager())
}

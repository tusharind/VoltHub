import SwiftUI

struct CitiesPerformanceView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var cities = CityPerformance.samples
    @State private var searchText = ""
    @State private var selectedStatus: CityStatus?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search cities...", text: $searchText)
                    .padding()
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter")
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            HStack {
                Text("\(filteredCities.count) cities")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.current.primary)
                }
            }
            .padding(.horizontal)

            if filteredCities.isEmpty {
                EmptyStateView(
                    icon: "building.2",
                    message: "No cities found",
                    description: cities.isEmpty
                        ? "No cities in this district yet"
                        : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCities) { city in
                            CityPerformanceCard(city: city)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredCities: [CityPerformance] {
        var result = cities

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.cityName.localizedCaseInsensitiveContains(searchText)
                    || $0.cityHeadName.localizedCaseInsensitiveContains(
                        searchText
                    )
            }
        }

        return result.sorted { $0.performanceScore > $1.performanceScore }
    }
}

struct CityPerformanceCard: View {
    let city: CityPerformance
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.cityName)
                        .font(.headline)

                    Text("Head: \(city.cityHeadName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    CityStatusBadge(status: city.status)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                        Text(String(format: "%.1f", city.performanceScore))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.orange)
                }
            }

            Divider()

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                CityMetric(
                    icon: "person.3.fill",
                    label: "Consumers",
                    value: "\(city.totalConsumers/1000)K"
                )

                CityMetric(
                    icon: "gauge.badge.plus",
                    label: "Active Meters",
                    value: "\(city.activeMeters/1000)K"
                )

                CityMetric(
                    icon: "indianrupeesign.circle.fill",
                    label: "Revenue",
                    value:
                        "₹\(String(format: "%.1f", Double(city.revenue)/1_000_000))M"
                )

                CityMetric(
                    icon: "percent",
                    label: "Collection",
                    value: "\(String(format: "%.1f", city.collectionRate))%"
                )
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Revenue Target")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    let achievement = (city.revenue / city.revenueTarget) * 100
                    Text("\(Int(achievement))% achieved")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(achievement >= 100 ? .green : .orange)
                }

                Spacer()

                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Label(
                            "\(city.powerOutages)",
                            systemImage: "bolt.slash.fill"
                        )
                        .font(.caption)
                        .foregroundColor(.red)

                        Label(
                            "\(city.pendingComplaints)",
                            systemImage: "exclamationmark.triangle.fill"
                        )
                        .font(.caption)
                        .foregroundColor(.orange)
                    }
                }
            }

            Button(action: {}) {
                HStack {
                    Text("View Details")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .font(.subheadline)
                .foregroundColor(themeManager.current.textOnPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(themeManager.current.primary)
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct CityMetric: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
    }
}

struct CityStatusBadge: View {
    let status: CityStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(6)
    }

    private var statusColor: Color {
        switch status {
        case .excellent: return .green
        case .good: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .needsAttention: return .orange
        case .critical: return .red
        }
    }
}

struct CityStatusFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? themeManager.current.primary
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(
                    isSelected ? themeManager.current.textOnPrimary : .primary
                )
                .cornerRadius(20)
        }
    }
}

#Preview {
    CitiesPerformanceView()
        .environmentObject(ThemeManager())
}

import SwiftUI

struct DistrictsOverviewView: View {
    @State private var districts = DistrictOverview.samples
    @State private var searchText = ""
    @State private var selectedStatus: DistrictHealthStatus?
    @State private var selectedState = "All States"

    private let states = [
        "All States", "Gujarat", "Maharashtra", "Karnataka", "Delhi",
        "West Bengal",
    ]

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search districts...", text: $searchText)
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
                Text("\(filteredDistricts.count) districts")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding(.horizontal)

            if filteredDistricts.isEmpty {
                EmptyStateView(
                    icon: "building.2",
                    message: "No districts found",
                    description: districts.isEmpty
                        ? "No districts in the system yet"
                        : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredDistricts) { district in
                            DistrictOverviewCard(district: district)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredDistricts: [DistrictOverview] {
        var result = districts

        if selectedState != "All States" {
            result = result.filter { $0.stateName == selectedState }
        }

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.districtName.localizedCaseInsensitiveContains(searchText)
                    || $0.stateName.localizedCaseInsensitiveContains(searchText)
                    || $0.districtHeadName.localizedCaseInsensitiveContains(
                        searchText
                    )
            }
        }

        return result.sorted { $0.performanceScore > $1.performanceScore }
    }
}

struct DistrictOverviewCard: View {
    let district: DistrictOverview

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(district.districtName)
                        .font(.headline)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(district.stateName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Text("Head: \(district.districtHeadName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    DistrictHealthBadge(status: district.status)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                        Text(String(format: "%.1f", district.performanceScore))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.orange)
                }
            }

            Divider()

            HStack(spacing: 20) {
                DistrictMetricItem(
                    icon: "building.fill",
                    label: "Cities",
                    value: "\(district.totalCities)"
                )

                DistrictMetricItem(
                    icon: "person.3.fill",
                    label: "Consumers",
                    value: formatNumber(district.totalConsumers)
                )

                DistrictMetricItem(
                    icon: "indianrupeesign.circle.fill",
                    label: "Revenue",
                    value:
                        "₹\(String(format: "%.1f", Double(district.monthlyRevenue)/1_000_000))M"
                )
            }

            Button(action: {}) {
                HStack {
                    Text("View Details")
                    Image(systemName: "arrow.right")
                }
                .font(.subheadline)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }

    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            return "\(number/1000)K"
        }
        return "\(number)"
    }
}

struct DistrictMetricItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
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

struct DistrictHealthBadge: View {
    let status: DistrictHealthStatus

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
        case .average: return .yellow
        case .needsImprovement: return .orange
        case .critical: return .red
        }
    }
}

struct DistrictHealthFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? Color(red: 0.2, green: 0.5, blue: 0.8)
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    DistrictsOverviewView()
}

import SwiftUI

struct CityHeadsManagementView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var cityHeads = CityHeadInfo.samples
    @State private var searchText = ""
    @State private var selectedStatus: CityHeadStatus?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search city heads...", text: $searchText)
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
                Text("\(filteredCityHeads.count) city heads")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Add City Head")
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(themeManager.current.primary)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)

            if filteredCityHeads.isEmpty {
                EmptyStateView(
                    icon: "person.3",
                    message: "No city heads found",
                    description: cityHeads.isEmpty
                        ? "No city heads assigned yet"
                        : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCityHeads) { head in
                            CityHeadCard(cityHead: head)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredCityHeads: [CityHeadInfo] {
        var result = cityHeads

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                    || $0.cityAssigned.localizedCaseInsensitiveContains(
                        searchText
                    ) || $0.email.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result.sorted { $0.performanceRating > $1.performanceRating }
    }
}

struct CityHeadCard: View {
    let cityHead: CityHeadInfo
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(themeManager.current.primary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(cityHead.name)
                        .font(.headline)

                    Text(cityHead.cityAssigned)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(
                                systemName: index
                                    < Int(cityHead.performanceRating)
                                    ? "star.fill" : "star"
                            )
                            .font(.caption)
                            .foregroundColor(.orange)
                        }
                        Text(String(format: "%.1f", cityHead.performanceRating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                CityHeadStatusBadge(status: cityHead.status)
            }

            Divider()

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    Text(cityHead.email)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    Spacer()
                }

                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    Text(cityHead.phone)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    Spacer()
                }

                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    Text("Joined \(cityHead.joiningDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    Spacer()
                }
            }

            Divider()

            LazyVGrid(
                columns: [
                    GridItem(.flexible()), GridItem(.flexible()),
                    GridItem(.flexible()),
                ],
                spacing: 12
            ) {
                CityHeadStat(
                    icon: "person.fill.checkmark",
                    label: "Workers",
                    value: "\(cityHead.totalWorkers)"
                )

                CityHeadStat(
                    icon: "checkmark.circle.fill",
                    label: "Completed",
                    value: "\(cityHead.tasksCompleted)"
                )

                CityHeadStat(
                    icon: "exclamationmark.circle.fill",
                    label: "Active Issues",
                    value: "\(cityHead.activeIssues)"
                )
            }

            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Message")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(themeManager.current.primary)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {}) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Details")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.current.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(themeManager.current.primary.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct CityHeadStat: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                .font(.title3)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct CityHeadStatusBadge: View {
    let status: CityHeadStatus

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
        case .active: return .green
        case .onLeave: return .orange
        case .training: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .inactive: return .gray
        }
    }
}

struct CityHeadFilterChip: View {
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
    CityHeadsManagementView()
        .environmentObject(ThemeManager())
}

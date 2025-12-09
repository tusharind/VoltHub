import SwiftUI

struct DistrictHeadsManagementView: View {
    @State private var districtHeads = DistrictHeadOverview.samples
    @State private var searchText = ""
    @State private var selectedStatus: ManagerStatus?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search district heads...", text: $searchText)
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

            Text("\(filteredDistrictHeads.count) district heads")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            if filteredDistrictHeads.isEmpty {
                EmptyStateView(
                    icon: "person.3",
                    message: "No district heads found",
                    description: districtHeads.isEmpty
                        ? "No district heads assigned yet"
                        : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredDistrictHeads) { head in
                            DistrictHeadManagementCard(districtHead: head)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredDistrictHeads: [DistrictHeadOverview] {
        var result = districtHeads

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                    || $0.districtAssigned.localizedCaseInsensitiveContains(
                        searchText
                    ) || $0.state.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result.sorted { $0.performanceRating > $1.performanceRating }
    }
}

struct DistrictHeadManagementCard: View {
    let districtHead: DistrictHeadOverview

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))

                VStack(alignment: .leading, spacing: 4) {
                    Text(districtHead.name)
                        .font(.headline)

                    HStack(spacing: 4) {
                        Image(systemName: "building.2.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(districtHead.districtAssigned)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(districtHead.state)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(
                                systemName: index
                                    < Int(districtHead.performanceRating)
                                    ? "star.fill" : "star"
                            )
                            .font(.caption)
                            .foregroundColor(
                                Color(red: 0.3, green: 0.4, blue: 0.5)
                            )
                        }
                        Text(
                            String(
                                format: "%.1f",
                                districtHead.performanceRating
                            )
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }

                Spacer()

                DistrictHeadStatusBadge(status: districtHead.status)
            }

            Divider()

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    Text(districtHead.email)
                        .font(.caption)
                    Spacer()
                }

                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    Text(districtHead.phone)
                        .font(.caption)
                    Spacer()
                }

                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    Text("Joined \(districtHead.joiningDate, style: .date)")
                        .font(.caption)
                    Spacer()
                }
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
}

struct DistrictHeadStatusBadge: View {
    let status: ManagerStatus

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
        case .suspended: return .red
        }
    }
}

struct DistrictHeadStatusFilterChip: View {
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
    DistrictHeadsManagementView()
}

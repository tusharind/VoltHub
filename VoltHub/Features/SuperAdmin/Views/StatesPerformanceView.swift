import SwiftUI

struct StatesPerformanceView: View {
    @State private var states = StatePerformance.samples
    @State private var searchText = ""
    @State private var selectedStatus: StateStatus?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search states...", text: $searchText)
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
            
            Text("\(filteredStates.count) states")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if filteredStates.isEmpty {
                EmptyStateView(
                    icon: "map",
                    message: "No states found",
                    description: states.isEmpty ? "No state data available" : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredStates) { state in
                            StatePerformanceCard(state: state)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var filteredStates: [StatePerformance] {
        var result = states
        
        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.stateName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.monthlyRevenue > $1.monthlyRevenue }
    }
}

struct StatePerformanceCard: View {
    let state: StatePerformance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(state.stateName)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("\(state.totalDistricts) Districts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                StateStatusBadge(status: state.status)
            }
            
            Divider()
            
            HStack(spacing: 20) {
                StateMetric(
                    icon: "person.3.fill",
                    label: "Consumers",
                    value: formatNumber(state.totalConsumers),
                    color: .green
                )
                
                StateMetric(
                    icon: "indianrupeesign.circle.fill",
                    label: "Revenue",
                    value: "₹\(String(format: "%.0f", Double(state.monthlyRevenue)/1000000))M",
                    color: Color(red: 0.2, green: 0.5, blue: 0.8)
                )
                
                StateMetric(
                    icon: "percent",
                    label: "Collection",
                    value: "\(String(format: "%.1f", state.collectionRate))%",
                    color: .purple
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
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return "\(number/1000)K"
        }
        return "\(number)"
    }
}

struct StateMetric: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct StateStatusBadge: View {
    let status: StateStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(6)
    }
    
    private var statusColor: Color {
        switch status {
        case .leading: return .green
        case .performing: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .moderate: return .orange
        case .lagging: return .red
        }
    }
}

struct StateStatusFilterChip: View {
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
                .background(isSelected ? Color(red: 0.2, green: 0.5, blue: 0.8) : Color(red: 0.94, green: 0.95, blue: 0.96))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    StatesPerformanceView()
}

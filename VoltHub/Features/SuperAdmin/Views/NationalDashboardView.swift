import SwiftUI

struct NationalDashboardView: View {
    @State private var dashboard = NationalDashboard.sample
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("National Overview - India")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Key Metrics Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    NationalMetricCard(
                        icon: "building.2.fill",
                        title: "Districts",
                        value: "\(dashboard.totalDistricts)",
                        color: Color(red: 0.2, green: 0.5, blue: 0.8)
                    )
                    
                    NationalMetricCard(
                        icon: "building.fill",
                        title: "Cities",
                        value: "\(dashboard.totalCities)",
                        color: .cyan
                    )
                    
                    NationalMetricCard(
                        icon: "person.3.fill",
                        title: "Consumers",
                        value: formatLargeNumber(dashboard.totalConsumers),
                        color: .green
                    )
                    
                    NationalMetricCard(
                        icon: "gauge.badge.plus",
                        title: "Active Meters",
                        value: formatLargeNumber(dashboard.totalMeters),
                        color: .indigo
                    )
                }
                .padding(.horizontal)
                
                // National Revenue Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "indianrupeesign.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("National Revenue")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("₹\(String(format: "%.2f", dashboard.nationalRevenue/10000000)) Cr")
                                .font(.system(size: 32, weight: .bold))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack {
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                Text("15.2%")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.green)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                            
                            Text("vs Last Month")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Critical Alerts
                HStack(spacing: 16) {
                    AlertMetricCard(
                        icon: "bolt.slash.fill",
                        title: "Power Outages",
                        value: "\(dashboard.totalPowerOutages)",
                        subtitle: "Across India",
                        color: .red
                    )
                    
                    AlertMetricCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Complaints",
                        value: "\(dashboard.totalComplaints)",
                        subtitle: "Pending",
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                // Top Performing Districts
                VStack(alignment: .leading, spacing: 12) {
                    Text("Top Districts")
                        .font(.headline)
                    
                    VStack(spacing: 10) {
                        TopPerformerRow(
                            rank: 1,
                            name: "Mumbai",
                            state: "Maharashtra",
                            score: 95.5,
                            color: .green
                        )
                        
                        TopPerformerRow(
                            rank: 2,
                            name: "Ahmedabad",
                            state: "Gujarat",
                            score: 92.0,
                            color: Color(red: 0.2, green: 0.5, blue: 0.8)
                        )
                        
                        TopPerformerRow(
                            rank: 3,
                            name: "Bangalore",
                            state: "Karnataka",
                            score: 88.5,
                            color: .purple
                        )
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000)
        }
        return "\(number)"
    }
    
    private func formatLargeNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.0fK", Double(number) / 1000)
        }
        return "\(number)"
    }
}

struct NationalMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct AlertMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .frame(width: 50, height: 50)
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct TopPerformerRow: View {
    let rank: Int
    let name: String
    let state: String
    let score: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .frame(width: 35)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(state)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.1f", score))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                
                Text("Score")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    NationalDashboardView()
}

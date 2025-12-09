import SwiftUI

struct DashboardOverviewView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var dashboard = DistrictDashboard.sample
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("District Overview")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(dashboard.districtName)
                        .font(.headline)
                        .foregroundColor(themeManager.current.primary)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        OverviewMetricCard(
                            icon: "building.2.fill",
                            title: "Total Cities",
                            value: "\(dashboard.totalCities)",
                            color: Color(red: 0.2, green: 0.5, blue: 0.8)
                        )
                        
                        OverviewMetricCard(
                            icon: "person.3.fill",
                            title: "Total Consumers",
                            value: formatNumber(dashboard.totalConsumers),
                            color: .green
                        )
                        
                        OverviewMetricCard(
                            icon: "person.fill.checkmark",
                            title: "Total Workers",
                            value: "\(dashboard.totalWorkers)",
                            color: .purple
                        )
                        
                        OverviewMetricCard(
                            icon: "gauge.badge.plus",
                            title: "Active Meters",
                            value: formatNumber(dashboard.totalMeters),
                            color: .orange
                        )
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "indianrupeesign.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Monthly Revenue")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("₹\(String(format: "%.2f", dashboard.monthlyRevenue/10000000)) Cr")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                            Text("12.5%")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Collection Rate")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(String(format: "%.1f", dashboard.collectionEfficiency))%")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Divider()
                            .frame(height: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Target Achievement")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("108%")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                .cornerRadius(12)
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    AlertCard(
                        icon: "bolt.slash.fill",
                        title: "Power Outages",
                        value: "\(dashboard.powerOutages)",
                        color: .red
                    )
                    
                    AlertCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Pending Complaints",
                        value: "\(dashboard.pendingComplaints)",
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        QuickActionRow(
                            icon: "doc.text.fill",
                            title: "Generate District Report",
                            color: Color(red: 0.2, green: 0.5, blue: 0.8)
                        )
                        
                        QuickActionRow(
                            icon: "person.badge.plus",
                            title: "Assign City Head",
                            color: .green
                        )
                        
                        QuickActionRow(
                            icon: "chart.bar.fill",
                            title: "View Performance Metrics",
                            color: .purple
                        )
                        
                        QuickActionRow(
                            icon: "bell.badge.fill",
                            title: "Send District Notification",
                            color: .orange
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
            return "\(number/1000)K"
        }
        return "\(number)"
    }
}

struct OverviewMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct AlertCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.1))
                    .cornerRadius(8)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardOverviewView()
        .environmentObject(ThemeManager())
}

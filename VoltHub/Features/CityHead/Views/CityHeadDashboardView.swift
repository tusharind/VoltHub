import SwiftUI

struct CityHeadDashboardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var metrics = DashboardMetrics.sample
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Real-time metrics and insights")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    MetricCard(
                        title: "Total Consumers",
                        value: "\(metrics.totalConsumers)",
                        icon: "person.3.fill",
                        color: Color(red: 0.2, green: 0.5, blue: 0.8)
                    )
                    
                    MetricCard(
                        title: "Active Meters",
                        value: "\(metrics.activeMeters)",
                        icon: "gauge.high",
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Total Workers",
                        value: "\(metrics.totalWorkers)",
                        icon: "person.fill.badge.plus",
                        color: .orange
                    )
                    
                    MetricCard(
                        title: "Pending Complaints",
                        value: "\(metrics.pendingComplaints)",
                        icon: "exclamationmark.triangle.fill",
                        color: .red
                    )
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    RevenueCard(revenue: metrics.revenueThisMonth)
                    
                    PowerOutageCard(outages: metrics.powerOutages)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        QuickActionButton(
                            title: "View All Areas",
                            icon: "map.fill",
                            action: {}
                        )
                        
                        QuickActionButton(
                            title: "Manage Workers",
                            icon: "person.3.fill",
                            action: {}
                        )
                        
                        QuickActionButton(
                            title: "Generate Report",
                            icon: "doc.text.fill",
                            action: {}
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct RevenueCard: View {
    let revenue: Double
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "indianrupeesign.circle.fill")
                    .font(.title)
                    .foregroundColor(themeManager.current.primary)
                
                Text("Revenue This Month")
                    .font(.headline)
                
                Spacer()
            }
            
            Text("₹\(String(format: "%.2f", revenue))")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(themeManager.current.primary)
            
            HStack {
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.green)
                Text("12% increase from last month")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(themeManager.current.primary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PowerOutageCard: View {
    let outages: Int
    
    var body: some View {
        HStack {
            Image(systemName: "bolt.slash.fill")
                .font(.title)
                .foregroundColor(outages > 0 ? .red : .green)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Power Outages")
                    .font(.headline)
                
                Text("\(outages) active incidents")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if outages > 0 {
                Button(action: {}) {
                    Text("View")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(themeManager.current.primary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

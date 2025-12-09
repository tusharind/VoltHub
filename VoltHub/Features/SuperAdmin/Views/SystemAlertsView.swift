import SwiftUI

struct SystemAlertsView: View {
    @State private var alerts = SystemAlert.samples
    @State private var selectedSeverity: AlertSeverity?
    @State private var showResolvedAlerts = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
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
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text("\(filteredAlerts.count) alerts")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Toggle("Show Resolved", isOn: $showResolvedAlerts)
                    .font(.caption)
                    .labelsHidden()
                
                Text(showResolvedAlerts ? "Show Resolved" : "Hide Resolved")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if filteredAlerts.isEmpty {
                EmptyStateView(
                    icon: "checkmark.shield.fill",
                    message: "No active alerts",
                    description: "System is running smoothly"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredAlerts) { alert in
                            SystemAlertCard(alert: alert)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var filteredAlerts: [SystemAlert] {
        var result = alerts
        
        if !showResolvedAlerts {
            result = result.filter { !$0.isResolved }
        }
        
        if let severity = selectedSeverity {
            result = result.filter { $0.severity == severity }
        }
        
        return result.sorted { $0.timestamp > $1.timestamp }
    }
}

struct SystemAlertCard: View {
    let alert: SystemAlert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: severityIcon)
                    .font(.title2)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(alert.title)
                            .font(.headline)
                        
                        Spacer()
                        
                        AlertSeverityBadge(severity: alert.severity)
                    }
                    
                    if let district = alert.district {
                        HStack(spacing: 4) {
                            Image(systemName: "building.2.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(district)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(alert.message)
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                        .lineLimit(3)
                }
            }
            
            Divider()
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(timeAgo(from: alert.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if alert.isResolved {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Resolved")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                } else {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Mark Resolved")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.2, green: 0.5, blue: 0.8))
                        .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
        }
        .padding()
        .background(alert.isResolved ? Color(red: 0.96, green: 0.97, blue: 0.98) : severityColor.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(alert.isResolved ? Color.clear : severityColor.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
    }
    
    private var severityIcon: String {
        switch alert.severity {
        case .critical: return "exclamationmark.octagon.fill"
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
    
    private var severityColor: Color {
        switch alert.severity {
        case .critical: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return Color(red: 0.2, green: 0.5, blue: 0.8)
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        
        if minutes < 60 {
            return "\(minutes)m ago"
        } else if hours < 24 {
            return "\(hours)h ago"
        } else {
            return "\(hours / 24)d ago"
        }
    }
}

struct AlertSeverityBadge: View {
    let severity: AlertSeverity
    
    var body: some View {
        Text(severity.rawValue)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(severityColor.opacity(0.2))
            .foregroundColor(severityColor)
            .cornerRadius(6)
    }
    
    private var severityColor: Color {
        switch severity {
        case .critical: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return Color(red: 0.2, green: 0.5, blue: 0.8)
        }
    }
}

struct AlertSeverityFilterChip: View {
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
    SystemAlertsView()
}

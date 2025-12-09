import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var reports = Report.samples
    @State private var selectedType: ReportType?
    
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
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Generate Report")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(themeManager.current.primary)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            if filteredReports.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    message: "No reports found",
                    description: "Generate a new report to get started"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredReports) { report in
                            ReportCard(report: report)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var filteredReports: [Report] {
        if let type = selectedType {
            return reports.filter { $0.reportType == type }
        }
        return reports
    }
}

struct ReportCard: View {
    let report: Report
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: reportIcon)
                    .font(.title2)
                    .foregroundColor(reportColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.title)
                        .font(.headline)
                    
                    Text(report.reportType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(reportColor.opacity(0.2))
                        .foregroundColor(reportColor)
                        .cornerRadius(6)
                }
                
                Spacer()
            }
            
            Divider()
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Generated: \(report.generatedDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    Text("Period: \(report.periodStart, style: .date) - \(report.periodEnd, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            Text(report.summary)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .padding(.top, 4)
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "eye.fill")
                        Text("View")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.current.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(themeManager.current.primary.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "square.and.arrow.down.fill")
                        Text("Download")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(themeManager.current.primary)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
    
    private var reportIcon: String {
        switch report.reportType {
        case .consumption:
            return "bolt.fill"
        case .revenue:
            return "indianrupeesign.circle.fill"
        case .complaints:
            return "exclamationmark.bubble.fill"
        case .workers:
            return "person.3.fill"
        case .meters:
            return "gauge.high"
        }
    }
    
    private var reportColor: Color {
        switch report.reportType {
        case .consumption:
            return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .revenue:
            return .green
        case .complaints:
            return .red
        case .workers:
            return .orange
        case .meters:
            return .purple
        }
    }
}

struct ReportFilterChip: View {
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
                .background(isSelected ? themeManager.current.primary : Color(red: 0.94, green: 0.95, blue: 0.96))
                .foregroundColor(isSelected ? themeManager.current.textOnPrimary : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    ReportsView()
        .environmentObject(ThemeManager())
}

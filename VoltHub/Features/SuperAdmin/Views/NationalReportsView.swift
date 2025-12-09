import SwiftUI

struct NationalReportsView: View {
    @State private var reports = NationalReport.samples
    @State private var selectedType: NationalReportType?
    @State private var selectedScope: ReportScope?
    @State private var showingGenerateReport = false
    
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
            
            Text("\(filteredReports.count) reports")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if filteredReports.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    message: "No reports found",
                    description: reports.isEmpty ? "No reports generated yet" : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredReports) { report in
                            NationalReportCard(report: report)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .sheet(isPresented: $showingGenerateReport) {
            GenerateNationalReportView()
        }
    }
    
    private var filteredReports: [NationalReport] {
        var result = reports
        
        if let type = selectedType {
            result = result.filter { $0.reportType == type }
        }
        
        if let scope = selectedScope {
            result = result.filter { $0.scope == scope }
        }
        
        return result.sorted { $0.generatedDate > $1.generatedDate }
    }
}

struct NationalReportCard: View {
    let report: NationalReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: report.reportType.icon)
                    .font(.title)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    .frame(width: 50, height: 50)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.reportTitle)
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        Text(report.reportType.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 3, height: 3)
                        
                        Text(report.scope.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1))
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                NationalReportStatusBadge(status: report.status)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Period")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(report.period)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Generated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(report.generatedDate, style: .date)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Size")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(report.fileSize)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            if report.status == .ready {
                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Text("View")
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
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.down.circle")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                            .frame(width: 44)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else if report.status == .generating {
                HStack {
                    ProgressView()
                    Text("Generating...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
    
    private var reportTypeColor: Color {
        switch report.reportType {
        case .financial: return .green
        case .operations: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .performance: return .purple
        case .compliance: return .orange
        case .strategic: return .cyan
        case .incident: return .red
        }
    }
}

struct NationalReportStatusBadge: View {
    let status: ReportStatus
    
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
        case .ready: return .green
        case .generating: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .failed: return .red
        }
    }
}

struct NationalReportTypeFilterChip: View {
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

struct NationalReportScopeChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color(red: 0.2, green: 0.5, blue: 0.8) : Color(red: 0.94, green: 0.95, blue: 0.96))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(12)
        }
    }
}

struct GenerateNationalReportView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var reportType: NationalReportType = .financial
    @State private var scope: ReportScope = .national
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Report Configuration")) {
                    Picker("Report Type", selection: $reportType) {
                        ForEach(NationalReportType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Scope", selection: $scope) {
                        ForEach(ReportScope.allCases, id: \.self) { scope in
                            Text(scope.rawValue).tag(scope)
                        }
                    }
                }
                
                Section(header: Text("Time Period")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Options")) {
                    Toggle("Include detailed breakdown", isOn: .constant(true))
                    Toggle("Include visual charts", isOn: .constant(true))
                    Toggle("Include comparison data", isOn: .constant(false))
                    Toggle("Send notification on completion", isOn: .constant(true))
                }
                
                Section {
                    Button(action: handleGenerate) {
                        Text("Generate Report")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                    }
                }
            }
            .navigationTitle("Generate National Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func handleGenerate() {
        dismiss()
    }
}

#Preview {
    NationalReportsView()
}

import SwiftUI

struct DistrictReportsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var reports = DistrictReport.samples
    @State private var selectedType: DistrictReportType?
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

            HStack {
                Text("\(filteredReports.count) reports")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: { showingGenerateReport = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Generate Report")
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

            if filteredReports.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    message: "No reports found",
                    description: reports.isEmpty
                        ? "No reports generated yet"
                        : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredReports) { report in
                            DistrictReportCard(report: report)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .sheet(isPresented: $showingGenerateReport) {
            GenerateReportFormView()
        }
    }

    private var filteredReports: [DistrictReport] {
        var result = reports

        if let type = selectedType {
            result = result.filter { $0.reportType == type }
        }

        return result.sorted { $0.generatedDate > $1.generatedDate }
    }
}

struct DistrictReportCard: View {
    let report: DistrictReport
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: report.reportType.icon)
                    .font(.title2)
                    .foregroundColor(reportTypeColor)
                    .frame(width: 44, height: 44)
                    .background(reportTypeColor.opacity(0.1))
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(report.reportTitle)
                        .font(.headline)

                    Text(report.reportType.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                ReportStatusBadge(status: report.status)
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
                            Image(systemName: "eye.fill")
                            Text("View")
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
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Download")
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

                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.primary)
                            .frame(width: 44)
                            .padding(.vertical, 10)
                            .background(
                                themeManager.current.primary.opacity(0.1)
                            )
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else if report.status == .generating {
                HStack {
                    ProgressView()
                    Text("Generating report...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }

    private var reportTypeColor: Color {
        switch report.reportType {
        case .revenue, .financial: return .green
        case .consumption: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .cityPerformance: return .purple
        case .complaints: return .orange
        case .operations: return .cyan
        }
    }
}

struct ReportStatusBadge: View {
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

struct DistrictReportFilterChip: View {
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

struct GenerateReportFormView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    @State private var reportType: DistrictReportType = .revenue
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var includeCities: [String] = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Report Type")) {
                    Picker("Type", selection: $reportType) {
                        ForEach(DistrictReportType.allCases, id: \.self) {
                            type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                Section(header: Text("Period")) {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        displayedComponents: .date
                    )
                }

                Section(header: Text("Options")) {
                    Toggle("Include all cities", isOn: .constant(true))
                    Toggle("Include worker details", isOn: .constant(false))
                    Toggle("Include financial breakdown", isOn: .constant(true))
                }

                Section {
                    Button(action: handleGenerate) {
                        Text("Generate Report")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(themeManager.current.primary)
                    }
                }
            }
            .navigationTitle("Generate District Report")
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
    DistrictReportsView()
        .environmentObject(ThemeManager())
}

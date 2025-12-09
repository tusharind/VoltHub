import Foundation

struct DistrictDashboard: Identifiable {
    let id = UUID()
    let districtName: String
    let totalCities: Int
    let totalConsumers: Int
    let totalWorkers: Int
    let totalMeters: Int
    let monthlyRevenue: Double
    let powerOutages: Int
    let pendingComplaints: Int
    let collectionEfficiency: Double
}

struct CityPerformance: Identifiable {
    let id = UUID()
    let cityName: String
    let cityHeadName: String
    let totalConsumers: Int
    let activeMeters: Int
    let revenue: Double
    let revenueTarget: Double
    let collectionRate: Double
    let pendingComplaints: Int
    let powerOutages: Int
    let performanceScore: Double
    let status: CityStatus
}

enum CityStatus: String, CaseIterable {
    case excellent = "Excellent"
    case good = "Good"
    case needsAttention = "Needs Attention"
    case critical = "Critical"

    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "blue"
        case .needsAttention: return "orange"
        case .critical: return "red"
        }
    }
}

struct CityHeadInfo: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let phone: String
    let cityAssigned: String
    let joiningDate: Date
    let totalWorkers: Int
    let activeIssues: Int
    let tasksCompleted: Int
    let performanceRating: Double
    let status: CityHeadStatus
}

enum CityHeadStatus: String, CaseIterable {
    case active = "Active"
    case onLeave = "On Leave"
    case training = "Training"
    case inactive = "Inactive"

    var color: String {
        switch self {
        case .active: return "green"
        case .onLeave: return "orange"
        case .training: return "blue"
        case .inactive: return "gray"
        }
    }
}

struct DistrictReport: Identifiable {
    let id = UUID()
    let reportTitle: String
    let reportType: DistrictReportType
    let generatedDate: Date
    let period: String
    let fileSize: String
    let status: ReportStatus
}

enum DistrictReportType: String, CaseIterable {
    case revenue = "Revenue Analysis"
    case consumption = "Consumption Report"
    case cityPerformance = "City Performance"
    case complaints = "Complaints Summary"
    case operations = "Operations Report"
    case financial = "Financial Report"

    var icon: String {
        switch self {
        case .revenue: return "dollarsign.circle.fill"
        case .consumption: return "chart.bar.fill"
        case .cityPerformance: return "star.fill"
        case .complaints: return "exclamationmark.triangle.fill"
        case .operations: return "gearshape.fill"
        case .financial: return "chart.pie.fill"
        }
    }
}

enum ReportStatus: String, CaseIterable {
    case ready = "Ready"
    case generating = "Generating"
    case failed = "Failed"
}

struct DistrictAnalytics: Identifiable {
    let id = UUID()
    let metric: String
    let currentValue: String
    let previousValue: String
    let percentageChange: Double
    let trend: TrendDirection
    let icon: String
}

enum TrendDirection {
    case up
    case down
    case stable
}

extension DistrictDashboard {
    static let sample = DistrictDashboard(
        districtName: "Ahmedabad District",
        totalCities: 8,
        totalConsumers: 125000,
        totalWorkers: 450,
        totalMeters: 120000,
        monthlyRevenue: 15_750_000,
        powerOutages: 12,
        pendingComplaints: 245,
        collectionEfficiency: 94.5
    )
}

extension CityPerformance {
    static let samples: [CityPerformance] = [
        CityPerformance(
            cityName: "Ahmedabad East",
            cityHeadName: "Rajesh Kumar",
            totalConsumers: 25000,
            activeMeters: 24500,
            revenue: 3_500_000,
            revenueTarget: 3_200_000,
            collectionRate: 96.5,
            pendingComplaints: 45,
            powerOutages: 2,
            performanceScore: 92.5,
            status: .excellent
        ),
        CityPerformance(
            cityName: "Ahmedabad West",
            cityHeadName: "Priya Sharma",
            totalConsumers: 22000,
            activeMeters: 21800,
            revenue: 3_100_000,
            revenueTarget: 3_000_000,
            collectionRate: 93.2,
            pendingComplaints: 38,
            powerOutages: 3,
            performanceScore: 88.0,
            status: .good
        ),
        CityPerformance(
            cityName: "Ahmedabad North",
            cityHeadName: "Amit Patel",
            totalConsumers: 18000,
            activeMeters: 17500,
            revenue: 2_200_000,
            revenueTarget: 2_500_000,
            collectionRate: 85.0,
            pendingComplaints: 62,
            powerOutages: 5,
            performanceScore: 72.0,
            status: .needsAttention
        ),
        CityPerformance(
            cityName: "Ahmedabad South",
            cityHeadName: "Sneha Desai",
            totalConsumers: 20000,
            activeMeters: 19000,
            revenue: 2_800_000,
            revenueTarget: 2_700_000,
            collectionRate: 91.5,
            pendingComplaints: 41,
            powerOutages: 2,
            performanceScore: 85.5,
            status: .good
        ),
    ]
}

extension CityHeadInfo {
    static let samples: [CityHeadInfo] = [
        CityHeadInfo(
            name: "Rajesh Kumar",
            email: "rajesh.kumar@voltpower.com",
            phone: "+91 98765 43210",
            cityAssigned: "Ahmedabad East",
            joiningDate: Date().addingTimeInterval(-365 * 24 * 60 * 60),
            totalWorkers: 85,
            activeIssues: 12,
            tasksCompleted: 485,
            performanceRating: 4.7,
            status: .active
        ),
        CityHeadInfo(
            name: "Priya Sharma",
            email: "priya.sharma@voltpower.com",
            phone: "+91 98765 43211",
            cityAssigned: "Ahmedabad West",
            joiningDate: Date().addingTimeInterval(-280 * 24 * 60 * 60),
            totalWorkers: 78,
            activeIssues: 8,
            tasksCompleted: 412,
            performanceRating: 4.5,
            status: .active
        ),
        CityHeadInfo(
            name: "Amit Patel",
            email: "amit.patel@voltpower.com",
            phone: "+91 98765 43212",
            cityAssigned: "Ahmedabad North",
            joiningDate: Date().addingTimeInterval(-180 * 24 * 60 * 60),
            totalWorkers: 62,
            activeIssues: 15,
            tasksCompleted: 298,
            performanceRating: 4.1,
            status: .active
        ),
        CityHeadInfo(
            name: "Sneha Desai",
            email: "sneha.desai@voltpower.com",
            phone: "+91 98765 43213",
            cityAssigned: "Ahmedabad South",
            joiningDate: Date().addingTimeInterval(-240 * 24 * 60 * 60),
            totalWorkers: 70,
            activeIssues: 9,
            tasksCompleted: 365,
            performanceRating: 4.4,
            status: .active
        ),
        CityHeadInfo(
            name: "Kiran Mehta",
            email: "kiran.mehta@voltpower.com",
            phone: "+91 98765 43214",
            cityAssigned: "Gandhinagar",
            joiningDate: Date().addingTimeInterval(-90 * 24 * 60 * 60),
            totalWorkers: 45,
            activeIssues: 5,
            tasksCompleted: 142,
            performanceRating: 4.0,
            status: .training
        ),
    ]
}

extension DistrictReport {
    static let samples: [DistrictReport] = [
        DistrictReport(
            reportTitle: "Q4 2025 Revenue Report",
            reportType: .revenue,
            generatedDate: Date().addingTimeInterval(-2 * 24 * 60 * 60),
            period: "Oct - Dec 2025",
            fileSize: "2.5 MB",
            status: .ready
        ),
        DistrictReport(
            reportTitle: "November Consumption Analysis",
            reportType: .consumption,
            generatedDate: Date().addingTimeInterval(-5 * 24 * 60 * 60),
            period: "November 2025",
            fileSize: "1.8 MB",
            status: .ready
        ),
        DistrictReport(
            reportTitle: "City Performance Review",
            reportType: .cityPerformance,
            generatedDate: Date().addingTimeInterval(-7 * 24 * 60 * 60),
            period: "November 2025",
            fileSize: "3.2 MB",
            status: .ready
        ),
        DistrictReport(
            reportTitle: "December Operations Report",
            reportType: .operations,
            generatedDate: Date(),
            period: "December 2025",
            fileSize: "Generating...",
            status: .generating
        ),
    ]
}

extension DistrictAnalytics {
    static let samples: [DistrictAnalytics] = [
        DistrictAnalytics(
            metric: "Total Revenue",
            currentValue: "₹15.75 Cr",
            previousValue: "₹14.20 Cr",
            percentageChange: 10.9,
            trend: .up,
            icon: "indianrupeesign.circle.fill"
        ),
        DistrictAnalytics(
            metric: "Collection Rate",
            currentValue: "94.5%",
            previousValue: "92.1%",
            percentageChange: 2.6,
            trend: .up,
            icon: "percent"
        ),
        DistrictAnalytics(
            metric: "Active Consumers",
            currentValue: "125K",
            previousValue: "122K",
            percentageChange: 2.5,
            trend: .up,
            icon: "person.3.fill"
        ),
        DistrictAnalytics(
            metric: "Power Outages",
            currentValue: "12",
            previousValue: "18",
            percentageChange: -33.3,
            trend: .down,
            icon: "bolt.slash.fill"
        ),
        DistrictAnalytics(
            metric: "Pending Complaints",
            currentValue: "245",
            previousValue: "312",
            percentageChange: -21.5,
            trend: .down,
            icon: "exclamationmark.triangle.fill"
        ),
        DistrictAnalytics(
            metric: "Worker Efficiency",
            currentValue: "87%",
            previousValue: "85%",
            percentageChange: 2.4,
            trend: .up,
            icon: "chart.line.uptrend.xyaxis"
        ),
    ]
}

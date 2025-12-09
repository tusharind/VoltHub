import Foundation

// MARK: - National Dashboard Models

struct NationalDashboard: Identifiable {
    let id = UUID()
    let totalDistricts: Int
    let totalCities: Int
    let totalConsumers: Int
    let totalWorkers: Int
    let totalMeters: Int
    let nationalRevenue: Double
    let totalPowerOutages: Int
    let totalComplaints: Int
    let avgCollectionRate: Double
    let activeStates: Int
}

// MARK: - District Overview Models

struct DistrictOverview: Identifiable {
    let id = UUID()
    let districtName: String
    let stateName: String
    let districtHeadName: String
    let totalCities: Int
    let totalConsumers: Int
    let monthlyRevenue: Double
    let revenueTarget: Double
    let collectionRate: Double
    let powerOutages: Int
    let complaints: Int
    let performanceScore: Double
    let status: DistrictHealthStatus
}

enum DistrictHealthStatus: String, CaseIterable {
    case excellent = "Excellent"
    case good = "Good"
    case average = "Average"
    case needsImprovement = "Needs Improvement"
    case critical = "Critical"
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "blue"
        case .average: return "yellow"
        case .needsImprovement: return "orange"
        case .critical: return "red"
        }
    }
}

// MARK: - State Performance Models

struct StatePerformance: Identifiable {
    let id = UUID()
    let stateName: String
    let totalDistricts: Int
    let totalConsumers: Int
    let monthlyRevenue: Double
    let collectionRate: Double
    let powerReliability: Double
    let avgResponseTime: String
    let status: StateStatus
}

enum StateStatus: String, CaseIterable {
    case leading = "Leading"
    case performing = "Performing"
    case moderate = "Moderate"
    case lagging = "Lagging"
}

// MARK: - District Head Models

struct DistrictHeadOverview: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let phone: String
    let districtAssigned: String
    let state: String
    let joiningDate: Date
    let totalCityHeads: Int
    let performanceRating: Double
    let revenueAchievement: Double
    let status: ManagerStatus
}

enum ManagerStatus: String, CaseIterable {
    case active = "Active"
    case onLeave = "On Leave"
    case training = "Training"
    case suspended = "Suspended"
    
    var color: String {
        switch self {
        case .active: return "green"
        case .onLeave: return "orange"
        case .training: return "blue"
        case .suspended: return "red"
        }
    }
}

// MARK: - National Report Models

struct NationalReport: Identifiable {
    let id = UUID()
    let reportTitle: String
    let reportType: NationalReportType
    let scope: ReportScope
    let generatedDate: Date
    let period: String
    let fileSize: String
    let status: ReportStatus
}

enum NationalReportType: String, CaseIterable {
    case financial = "Financial Summary"
    case operations = "Operations Report"
    case performance = "Performance Analysis"
    case compliance = "Compliance Report"
    case strategic = "Strategic Overview"
    case incident = "Incident Report"
    
    var icon: String {
        switch self {
        case .financial: return "chart.pie.fill"
        case .operations: return "gearshape.2.fill"
        case .performance: return "chart.bar.fill"
        case .compliance: return "checkmark.shield.fill"
        case .strategic: return "flag.fill"
        case .incident: return "exclamationmark.octagon.fill"
        }
    }
}

enum ReportScope: String, CaseIterable {
    case national = "National"
    case state = "State"
    case district = "District"
    case custom = "Custom"
}

// MARK: - System Settings Models

struct SystemSetting: Identifiable {
    let id = UUID()
    let category: SettingCategory
    let name: String
    let description: String
    let isEnabled: Bool
}

enum SettingCategory: String, CaseIterable {
    case billing = "Billing"
    case operations = "Operations"
    case security = "Security"
    case notifications = "Notifications"
    case integrations = "Integrations"
}

// MARK: - Alert Models

struct SystemAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let severity: AlertSeverity
    let district: String?
    let timestamp: Date
    let isResolved: Bool
}

enum AlertSeverity: String, CaseIterable {
    case critical = "Critical"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: String {
        switch self {
        case .critical: return "red"
        case .high: return "orange"
        case .medium: return "yellow"
        case .low: return "blue"
        }
    }
}

// MARK: - Sample Data

extension NationalDashboard {
    static let sample = NationalDashboard(
        totalDistricts: 45,
        totalCities: 280,
        totalConsumers: 8500000,
        totalWorkers: 12500,
        totalMeters: 8200000,
        nationalRevenue: 1250000000,
        totalPowerOutages: 156,
        totalComplaints: 3450,
        avgCollectionRate: 92.8,
        activeStates: 15
    )
}

extension DistrictOverview {
    static let samples: [DistrictOverview] = [
        DistrictOverview(
            districtName: "Ahmedabad District",
            stateName: "Gujarat",
            districtHeadName: "Ramesh Patel",
            totalCities: 8,
            totalConsumers: 125000,
            monthlyRevenue: 15750000,
            revenueTarget: 15000000,
            collectionRate: 94.5,
            powerOutages: 12,
            complaints: 245,
            performanceScore: 92.0,
            status: .excellent
        ),
        DistrictOverview(
            districtName: "Mumbai District",
            stateName: "Maharashtra",
            districtHeadName: "Priya Sharma",
            totalCities: 12,
            totalConsumers: 285000,
            monthlyRevenue: 42500000,
            revenueTarget: 40000000,
            collectionRate: 96.2,
            powerOutages: 8,
            complaints: 412,
            performanceScore: 95.5,
            status: .excellent
        ),
        DistrictOverview(
            districtName: "Delhi District",
            stateName: "Delhi",
            districtHeadName: "Amit Kumar",
            totalCities: 15,
            totalConsumers: 320000,
            monthlyRevenue: 48000000,
            revenueTarget: 50000000,
            collectionRate: 89.5,
            powerOutages: 25,
            complaints: 580,
            performanceScore: 78.0,
            status: .average
        ),
        DistrictOverview(
            districtName: "Bangalore District",
            stateName: "Karnataka",
            districtHeadName: "Sneha Reddy",
            totalCities: 10,
            totalConsumers: 195000,
            monthlyRevenue: 28500000,
            revenueTarget: 27000000,
            collectionRate: 93.8,
            powerOutages: 15,
            complaints: 320,
            performanceScore: 88.5,
            status: .good
        ),
        DistrictOverview(
            districtName: "Kolkata District",
            stateName: "West Bengal",
            districtHeadName: "Rajesh Banerjee",
            totalCities: 9,
            totalConsumers: 165000,
            monthlyRevenue: 22000000,
            revenueTarget: 25000000,
            collectionRate: 85.2,
            powerOutages: 32,
            complaints: 495,
            performanceScore: 72.0,
            status: .needsImprovement
        )
    ]
}

extension StatePerformance {
    static let samples: [StatePerformance] = [
        StatePerformance(
            stateName: "Maharashtra",
            totalDistricts: 8,
            totalConsumers: 1250000,
            monthlyRevenue: 185000000,
            collectionRate: 95.5,
            powerReliability: 98.5,
            avgResponseTime: "2.5 hrs",
            status: .leading
        ),
        StatePerformance(
            stateName: "Gujarat",
            totalDistricts: 6,
            totalConsumers: 850000,
            monthlyRevenue: 125000000,
            collectionRate: 94.2,
            powerReliability: 97.8,
            avgResponseTime: "3.0 hrs",
            status: .leading
        ),
        StatePerformance(
            stateName: "Karnataka",
            totalDistricts: 7,
            totalConsumers: 950000,
            monthlyRevenue: 142000000,
            collectionRate: 92.8,
            powerReliability: 96.5,
            avgResponseTime: "3.5 hrs",
            status: .performing
        ),
        StatePerformance(
            stateName: "Tamil Nadu",
            totalDistricts: 9,
            totalConsumers: 1150000,
            monthlyRevenue: 168000000,
            collectionRate: 91.5,
            powerReliability: 95.8,
            avgResponseTime: "4.0 hrs",
            status: .performing
        )
    ]
}

extension DistrictHeadOverview {
    static let samples: [DistrictHeadOverview] = [
        DistrictHeadOverview(
            name: "Ramesh Patel",
            email: "ramesh.patel@voltpower.com",
            phone: "+91 98765 00001",
            districtAssigned: "Ahmedabad District",
            state: "Gujarat",
            joiningDate: Date().addingTimeInterval(-730*24*60*60),
            totalCityHeads: 8,
            performanceRating: 4.6,
            revenueAchievement: 105.0,
            status: .active
        ),
        DistrictHeadOverview(
            name: "Priya Sharma",
            email: "priya.sharma@voltpower.com",
            phone: "+91 98765 00002",
            districtAssigned: "Mumbai District",
            state: "Maharashtra",
            joiningDate: Date().addingTimeInterval(-640*24*60*60),
            totalCityHeads: 12,
            performanceRating: 4.8,
            revenueAchievement: 106.3,
            status: .active
        ),
        DistrictHeadOverview(
            name: "Amit Kumar",
            email: "amit.kumar@voltpower.com",
            phone: "+91 98765 00003",
            districtAssigned: "Delhi District",
            state: "Delhi",
            joiningDate: Date().addingTimeInterval(-450*24*60*60),
            totalCityHeads: 15,
            performanceRating: 3.9,
            revenueAchievement: 96.0,
            status: .active
        )
    ]
}

extension NationalReport {
    static let samples: [NationalReport] = [
        NationalReport(
            reportTitle: "Q4 2025 Financial Summary",
            reportType: .financial,
            scope: .national,
            generatedDate: Date().addingTimeInterval(-1*24*60*60),
            period: "Oct - Dec 2025",
            fileSize: "8.5 MB",
            status: .ready
        ),
        NationalReport(
            reportTitle: "November Operations Report",
            reportType: .operations,
            scope: .national,
            generatedDate: Date().addingTimeInterval(-3*24*60*60),
            period: "November 2025",
            fileSize: "6.2 MB",
            status: .ready
        ),
        NationalReport(
            reportTitle: "Maharashtra State Performance",
            reportType: .performance,
            scope: .state,
            generatedDate: Date().addingTimeInterval(-5*24*60*60),
            period: "November 2025",
            fileSize: "4.8 MB",
            status: .ready
        )
    ]
}

extension SystemAlert {
    static let samples: [SystemAlert] = [
        SystemAlert(
            title: "Critical Power Outage",
            message: "Multiple areas in Kolkata District experiencing power outage",
            severity: .critical,
            district: "Kolkata District",
            timestamp: Date().addingTimeInterval(-30*60),
            isResolved: false
        ),
        SystemAlert(
            title: "Revenue Target Not Met",
            message: "Delhi District is 4% below monthly revenue target",
            severity: .high,
            district: "Delhi District",
            timestamp: Date().addingTimeInterval(-2*60*60),
            isResolved: false
        ),
        SystemAlert(
            title: "High Complaint Volume",
            message: "Unusual spike in complaints in Mumbai District",
            severity: .medium,
            district: "Mumbai District",
            timestamp: Date().addingTimeInterval(-5*60*60),
            isResolved: true
        )
    ]
}

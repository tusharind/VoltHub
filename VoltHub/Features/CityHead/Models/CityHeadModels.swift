import Foundation

struct DashboardMetrics: Identifiable {
    let id: String
    let totalConsumers: Int
    let totalWorkers: Int
    let activeMeters: Int
    let pendingComplaints: Int
    let revenueThisMonth: Double
    let powerOutages: Int

    init(
        id: String = UUID().uuidString,
        totalConsumers: Int,
        totalWorkers: Int,
        activeMeters: Int,
        pendingComplaints: Int,
        revenueThisMonth: Double,
        powerOutages: Int
    ) {
        self.id = id
        self.totalConsumers = totalConsumers
        self.totalWorkers = totalWorkers
        self.activeMeters = activeMeters
        self.pendingComplaints = pendingComplaints
        self.revenueThisMonth = revenueThisMonth
        self.powerOutages = powerOutages
    }
}

struct Area: Identifiable, Hashable {
    let id: String
    let name: String
    let totalConsumers: Int
    let activeMeters: Int
    let pendingIssues: Int
    let assignedWorkers: Int

    init(
        id: String = UUID().uuidString,
        name: String,
        totalConsumers: Int,
        activeMeters: Int,
        pendingIssues: Int,
        assignedWorkers: Int
    ) {
        self.id = id
        self.name = name
        self.totalConsumers = totalConsumers
        self.activeMeters = activeMeters
        self.pendingIssues = pendingIssues
        self.assignedWorkers = assignedWorkers
    }
}

struct Worker: Identifiable, Hashable {
    let id: String
    let name: String
    let employeeID: String
    let contactNumber: String
    let assignedArea: String
    let tasksCompleted: Int
    let tasksInProgress: Int
    let status: WorkerStatus

    init(
        id: String = UUID().uuidString,
        name: String,
        employeeID: String,
        contactNumber: String,
        assignedArea: String,
        tasksCompleted: Int,
        tasksInProgress: Int,
        status: WorkerStatus = .active
    ) {
        self.id = id
        self.name = name
        self.employeeID = employeeID
        self.contactNumber = contactNumber
        self.assignedArea = assignedArea
        self.tasksCompleted = tasksCompleted
        self.tasksInProgress = tasksInProgress
        self.status = status
    }
}

enum WorkerStatus: String, CaseIterable, Identifiable {
    case active = "Active"
    case onLeave = "On Leave"
    case inactive = "Inactive"

    var id: String { rawValue }
}

struct Report: Identifiable {
    let id: String
    let title: String
    let reportType: ReportType
    let generatedDate: Date
    let periodStart: Date
    let periodEnd: Date
    let summary: String

    init(
        id: String = UUID().uuidString,
        title: String,
        reportType: ReportType,
        generatedDate: Date = Date(),
        periodStart: Date,
        periodEnd: Date,
        summary: String
    ) {
        self.id = id
        self.title = title
        self.reportType = reportType
        self.generatedDate = generatedDate
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.summary = summary
    }
}

enum ReportType: String, CaseIterable, Identifiable {
    case consumption = "Consumption"
    case revenue = "Revenue"
    case complaints = "Complaints"
    case workers = "Workers"
    case meters = "Meters"

    var id: String { rawValue }
}

extension DashboardMetrics {
    static let sample = DashboardMetrics(
        totalConsumers: 12543,
        totalWorkers: 45,
        activeMeters: 12100,
        pendingComplaints: 28,
        revenueThisMonth: 8750000.00,
        powerOutages: 3
    )
}

extension Area {
    static let samples: [Area] = [
        Area(
            name: "North Zone",
            totalConsumers: 3500,
            activeMeters: 3400,
            pendingIssues: 8,
            assignedWorkers: 12
        ),
        Area(
            name: "South Zone",
            totalConsumers: 2800,
            activeMeters: 2750,
            pendingIssues: 5,
            assignedWorkers: 10
        ),
        Area(
            name: "East Zone",
            totalConsumers: 3100,
            activeMeters: 3000,
            pendingIssues: 10,
            assignedWorkers: 11
        ),
        Area(
            name: "West Zone",
            totalConsumers: 3143,
            activeMeters: 2950,
            pendingIssues: 5,
            assignedWorkers: 12
        ),
    ]
}

extension Worker {
    static let samples: [Worker] = [
        Worker(
            name: "Rajesh Kumar",
            employeeID: "EMP001",
            contactNumber: "+91 98765 43210",
            assignedArea: "North Zone",
            tasksCompleted: 145,
            tasksInProgress: 3,
            status: .active
        ),
        Worker(
            name: "Priya Sharma",
            employeeID: "EMP002",
            contactNumber: "+91 98765 43211",
            assignedArea: "South Zone",
            tasksCompleted: 132,
            tasksInProgress: 2,
            status: .active
        ),
        Worker(
            name: "Amit Patel",
            employeeID: "EMP003",
            contactNumber: "+91 98765 43212",
            assignedArea: "East Zone",
            tasksCompleted: 98,
            tasksInProgress: 5,
            status: .active
        ),
        Worker(
            name: "Sunita Verma",
            employeeID: "EMP004",
            contactNumber: "+91 98765 43213",
            assignedArea: "West Zone",
            tasksCompleted: 156,
            tasksInProgress: 1,
            status: .active
        ),
        Worker(
            name: "Vikram Singh",
            employeeID: "EMP005",
            contactNumber: "+91 98765 43214",
            assignedArea: "North Zone",
            tasksCompleted: 87,
            tasksInProgress: 0,
            status: .onLeave
        ),
    ]
}

extension Report {
    static let samples: [Report] = [
        Report(
            title: "November 2025 Consumption Report",
            reportType: .consumption,
            periodStart: Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: Date()
            )!,
            periodEnd: Date(),
            summary: "Total consumption: 2.5M kWh across all zones"
        ),
        Report(
            title: "November 2025 Revenue Report",
            reportType: .revenue,
            periodStart: Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: Date()
            )!,
            periodEnd: Date(),
            summary: "Total revenue: ₹8.75M with 95% collection rate"
        ),
        Report(
            title: "Complaints Analysis Q4",
            reportType: .complaints,
            periodStart: Calendar.current.date(
                byAdding: .month,
                value: -3,
                to: Date()
            )!,
            periodEnd: Date(),
            summary: "124 complaints resolved, avg resolution time: 2.5 days"
        ),
    ]
}

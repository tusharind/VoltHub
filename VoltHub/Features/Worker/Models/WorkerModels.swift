import Foundation

enum TaskType: String, CaseIterable, Identifiable {
    case takeReading = "Take Reading"
    case installMeter = "Install Meter"

    var id: String { rawValue }
}

enum TaskStatus: String, CaseIterable {
    case pending = "Pending"
    case completed = "Completed"

    var id: String { rawValue }
}

struct WorkerTask: Identifiable {
    let id: String
    let title: String
    let description: String
    let meterID: String?
    let type: TaskType
    var status: TaskStatus
    let assignedDate: Date
    let location: String?

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        meterID: String? = nil,
        type: TaskType,
        status: TaskStatus = .pending,
        assignedDate: Date = Date(),
        location: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.meterID = meterID
        self.type = type
        self.status = status
        self.assignedDate = assignedDate
        self.location = location
    }
}

// Sample data for preview/testing
extension WorkerTask {
    static let samples: [WorkerTask] = [
        WorkerTask(
            title: "Monthly Reading - Building A",
            description:
                "Take monthly electricity reading for Building A, Floor 3",
            meterID: "MTR-001",
            type: .takeReading,
            status: .pending,
            location: "Building A, Floor 3"
        ),
        WorkerTask(
            title: "New Meter Installation",
            description: "Install new smart meter at residential complex",
            meterID: "MTR-NEW-045",
            type: .installMeter,
            status: .pending,
            location: "Green Valley Apartments, Unit 402"
        ),
        WorkerTask(
            title: "Reading - Commercial Zone",
            description: "Collect readings for commercial area meters",
            meterID: "MTR-COM-12",
            type: .takeReading,
            status: .completed,
            location: "Commercial Zone, Block C"
        ),
    ]
}

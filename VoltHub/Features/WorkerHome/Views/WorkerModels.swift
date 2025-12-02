import Foundation

public enum TaskType: String, CaseIterable, Identifiable {
    case reading = "Take Reading"
    case install = "Install Meter"
    public var id: String { rawValue }
}
public enum TaskStatus: String, CaseIterable, Identifiable {
    case pending, completed
    public var id: String { rawValue }
}
public struct WorkerTask: Identifiable, Hashable {
    public var id: UUID
    public var title: String
    public var description: String
    public var type: TaskType
    public var status: TaskStatus
    public var meterId: String?
    public init(
        id: UUID,
        title: String,
        description: String,
        type: TaskType,
        status: TaskStatus,
        meterId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.status = status
        self.meterId = meterId
    }
}

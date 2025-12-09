import Foundation

public struct Employee: Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let role: EmployeeRole
    public let status: EmployeeStatus
    public init(
        id: UUID,
        name: String,
        role: EmployeeRole,
        status: EmployeeStatus
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.status = status
    }
}

public enum EmployeeRole: String, CaseIterable, Identifiable {
    case admin, staff
    public var id: String { rawValue }
}
public enum EmployeeStatus: String, CaseIterable, Identifiable {
    case active, inactive
    public var id: String { rawValue }
}
public enum EmployeeFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case admin = "Admin"
    case staff = "Staff"
    public var id: String { rawValue }
}

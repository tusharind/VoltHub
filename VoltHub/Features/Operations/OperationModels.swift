import Foundation

public enum OpsLevel: String, CaseIterable, Identifiable {
    case states = "States"
    case districts = "Districts"
    case cities = "Cities"
    public var id: String { rawValue }
}

public protocol NamedHeadedEntity {
    var id: UUID { get }
    var name: String { get }
    var head: String { get }
}

public struct OperationState: Identifiable, Hashable, NamedHeadedEntity {
    public var id: UUID
    public var name: String
    public var head: String
    public init(id: UUID, name: String, head: String) {
        self.id = id
        self.name = name
        self.head = head
    }
}
public struct OperationDistrict: Identifiable, Hashable, NamedHeadedEntity {
    public var id: UUID
    public var name: String
    public var head: String
    public init(id: UUID, name: String, head: String) {
        self.id = id
        self.name = name
        self.head = head
    }
}
public struct OperationCity: Identifiable, Hashable, NamedHeadedEntity {
    public var id: UUID
    public var name: String
    public var head: String
    public init(id: UUID, name: String, head: String) {
        self.id = id
        self.name = name
        self.head = head
    }
}

public enum OperationEntity: Identifiable, Hashable {
    public enum Kind: String { case state, district, city }
    case state(OperationState)
    case district(OperationDistrict)
    case city(OperationCity)
    public var id: UUID {
        switch self {
        case .state(let v): return v.id
        case .district(let v): return v.id
        case .city(let v): return v.id
        }
    }
    public var title: String {
        switch self {
        case .state(let v): return v.name
        case .district(let v): return v.name
        case .city(let v): return v.name
        }
    }
    public var head: String {
        switch self {
        case .state(let v): return v.head
        case .district(let v): return v.head
        case .city(let v): return v.head
        }
    }
    public var kind: Kind {
        switch self {
        case .state: return .state
        case .district: return .district
        case .city: return .city
        }
    }
}

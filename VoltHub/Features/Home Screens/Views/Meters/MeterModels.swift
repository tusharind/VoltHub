import Foundation

struct Meter: Identifiable, Hashable {
    let id: UUID
    let name: String
    let type: MeterType
    let status: MeterStatus
}

enum MeterType: String, CaseIterable, Identifiable {
    case electric, water, gas
    var id: String { rawValue }
}

enum MeterStatus: String, CaseIterable, Identifiable {
    case active, inactive
    var id: String { rawValue }
}

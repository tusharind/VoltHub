import SwiftUI

struct EmployeeDraft {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var role: Role = .none
    var locationName: String = ""
}

enum Role: String, CaseIterable, Identifiable {
    case Admin
    case India_Head
    case State_Head
    case District_Head
    case City_Head
    case Support_Team
    case Worker
    case none

    var id: String { rawValue }

    var displayName: String {
        rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }
}


import SwiftUI

@MainActor
final class AddEmployeeViewModel: ObservableObject {

    @Published var draft = EmployeeDraft()
    @Published var allowedRoles: [Role] = []

    @Published var isSubmitting = false
    @Published var submitMessage: String?

    let currentUserRole: Role

    init(currentUserRole: Role) {
        self.currentUserRole = currentUserRole
        self.allowedRoles = Self.rolesAllowed(for: currentUserRole)
    }

    static func rolesAllowed(for role: Role) -> [Role] {
        switch role {
        case .Admin:
            return [.India_Head,.State_Head, .District_Head, .City_Head]
        case .India_Head:
            return [.State_Head, .District_Head, .City_Head]
        case .State_Head:
            return [.District_Head, .City_Head]
        case .District_Head:
            return [.City_Head]
        case .City_Head:
            return [.Support_Team, .Worker]
        default:
            return []
        }
    }

    func submit() {
        isSubmitting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.submitMessage = "Employee Added Successfully!"
            self.isSubmitting = false
        }
    }
}


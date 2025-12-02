import Foundation

public struct Bill: Identifiable, Hashable {
    public var id: UUID
    public var accountNumber: String
    public var description: String
    public var amount: Double
    public var dueDate: Date
    public var status: BillStatus
    public init(
        id: UUID,
        accountNumber: String,
        description: String,
        amount: Double,
        dueDate: Date,
        status: BillStatus
    ) {
        self.id = id
        self.accountNumber = accountNumber
        self.description = description
        self.amount = amount
        self.dueDate = dueDate
        self.status = status
    }
}

public enum BillStatus: String, CaseIterable { case unpaid, paid }

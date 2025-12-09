import Foundation

struct Bill: Identifiable, Hashable {
    let id: String
    let accountNumber: String
    let meterID: String
    let billingPeriod: String
    let amount: Double
    let dueDate: Date
    var status: BillStatus
    let unitsConsumed: Int
    let previousReading: Int
    let currentReading: Int
    
    init(
        id: String = UUID().uuidString,
        accountNumber: String,
        meterID: String,
        billingPeriod: String,
        amount: Double,
        dueDate: Date,
        status: BillStatus = .unpaid,
        unitsConsumed: Int,
        previousReading: Int,
        currentReading: Int
    ) {
        self.id = id
        self.accountNumber = accountNumber
        self.meterID = meterID
        self.billingPeriod = billingPeriod
        self.amount = amount
        self.dueDate = dueDate
        self.status = status
        self.unitsConsumed = unitsConsumed
        self.previousReading = previousReading
        self.currentReading = currentReading
    }
}

enum BillStatus: String, CaseIterable, Identifiable {
    case paid = "Paid"
    case unpaid = "Unpaid"
    case overdue = "Overdue"
    
    var id: String { rawValue }
}

struct ConnectionRequest: Identifiable {
    let id: String
    var applicantName: String
    var address: String
    var contactNumber: String
    var emailAddress: String
    var connectionType: ConnectionType
    var loadRequired: String
    var status: ConnectionStatus
    let submittedDate: Date
    
    init(
        id: String = UUID().uuidString,
        applicantName: String = "",
        address: String = "",
        contactNumber: String = "",
        emailAddress: String = "",
        connectionType: ConnectionType = .residential,
        loadRequired: String = "",
        status: ConnectionStatus = .pending,
        submittedDate: Date = Date()
    ) {
        self.id = id
        self.applicantName = applicantName
        self.address = address
        self.contactNumber = contactNumber
        self.emailAddress = emailAddress
        self.connectionType = connectionType
        self.loadRequired = loadRequired
        self.status = status
        self.submittedDate = submittedDate
    }
}

enum ConnectionType: String, CaseIterable, Identifiable {
    case residential = "Residential"
    case commercial = "Commercial"
    case industrial = "Industrial"
    
    var id: String { rawValue }
}

enum ConnectionStatus: String {
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Rejected"
    case completed = "Completed"
}

struct Complaint: Identifiable {
    let id: String
    var subject: String
    var description: String
    var category: ComplaintCategory
    var priority: ComplaintPriority
    var status: ComplaintStatus
    let submittedDate: Date
    var resolvedDate: Date?
    
    init(
        id: String = UUID().uuidString,
        subject: String = "",
        description: String = "",
        category: ComplaintCategory = .billing,
        priority: ComplaintPriority = .medium,
        status: ComplaintStatus = .open,
        submittedDate: Date = Date(),
        resolvedDate: Date? = nil
    ) {
        self.id = id
        self.subject = subject
        self.description = description
        self.category = category
        self.priority = priority
        self.status = status
        self.submittedDate = submittedDate
        self.resolvedDate = resolvedDate
    }
}

enum ComplaintCategory: String, CaseIterable, Identifiable {
    case billing = "Billing"
    case powerOutage = "Power Outage"
    case meterIssue = "Meter Issue"
    case qualityIssue = "Power Quality"
    case other = "Other"
    
    var id: String { rawValue }
}

enum ComplaintPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    var id: String { rawValue }
}

enum ComplaintStatus: String {
    case open = "Open"
    case inProgress = "In Progress"
    case resolved = "Resolved"
    case closed = "Closed"
}

// MARK: - Sample Data

extension Bill {
    static let samples: [Bill] = [
        Bill(
            accountNumber: "ACC-12345",
            meterID: "MTR-001",
            billingPeriod: "Nov 2025",
            amount: 2450.50,
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            status: .unpaid,
            unitsConsumed: 245,
            previousReading: 1000,
            currentReading: 1245
        ),
        Bill(
            accountNumber: "ACC-12345",
            meterID: "MTR-001",
            billingPeriod: "Oct 2025",
            amount: 2100.00,
            dueDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            status: .paid,
            unitsConsumed: 210,
            previousReading: 790,
            currentReading: 1000
        ),
        Bill(
            accountNumber: "ACC-12345",
            meterID: "MTR-001",
            billingPeriod: "Sep 2025",
            amount: 1850.00,
            dueDate: Calendar.current.date(byAdding: .day, value: -40, to: Date())!,
            status: .paid,
            unitsConsumed: 185,
            previousReading: 605,
            currentReading: 790
        )
    ]
}


import Foundation

struct SupportTicket: Identifiable, Hashable {
    let id: String
    let ticketNumber: String
    let consumerName: String
    let consumerContact: String
    let issueCategory: IssueCategory
    let priority: TicketPriority
    let status: TicketStatus
    let description: String
    let submittedDate: Date
    let assignedTo: String?
    let resolvedDate: Date?

    init(
        id: String = UUID().uuidString,
        ticketNumber: String,
        consumerName: String,
        consumerContact: String,
        issueCategory: IssueCategory,
        priority: TicketPriority,
        status: TicketStatus,
        description: String,
        submittedDate: Date = Date(),
        assignedTo: String? = nil,
        resolvedDate: Date? = nil
    ) {
        self.id = id
        self.ticketNumber = ticketNumber
        self.consumerName = consumerName
        self.consumerContact = consumerContact
        self.issueCategory = issueCategory
        self.priority = priority
        self.status = status
        self.description = description
        self.submittedDate = submittedDate
        self.assignedTo = assignedTo
        self.resolvedDate = resolvedDate
    }
}

enum IssueCategory: String, CaseIterable, Identifiable {
    case billing = "Billing"
    case powerOutage = "Power Outage"
    case meterIssue = "Meter Issue"
    case connectionRequest = "Connection Request"
    case technical = "Technical"
    case other = "Other"

    var id: String { rawValue }
}

enum TicketPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"

    var id: String { rawValue }
}

enum TicketStatus: String, CaseIterable, Identifiable {
    case open = "Open"
    case inProgress = "In Progress"
    case resolved = "Resolved"
    case closed = "Closed"

    var id: String { rawValue }
}

struct FAQ: Identifiable, Hashable {
    let id: String
    let question: String
    let answer: String
    let category: FAQCategory

    init(
        id: String = UUID().uuidString,
        question: String,
        answer: String,
        category: FAQCategory
    ) {
        self.id = id
        self.question = question
        self.answer = answer
        self.category = category
    }
}

enum FAQCategory: String, CaseIterable, Identifiable {
    case billing = "Billing"
    case meters = "Meters"
    case connection = "Connection"
    case complaints = "Complaints"
    case general = "General"

    var id: String { rawValue }
}

struct KnowledgeArticle: Identifiable, Hashable {
    let id: String
    let title: String
    let content: String
    let category: ArticleCategory
    let lastUpdated: Date
    let views: Int

    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        category: ArticleCategory,
        lastUpdated: Date = Date(),
        views: Int = 0
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.lastUpdated = lastUpdated
        self.views = views
    }
}

enum ArticleCategory: String, CaseIterable, Identifiable {
    case troubleshooting = "Troubleshooting"
    case howTo = "How To"
    case policies = "Policies"
    case technical = "Technical"

    var id: String { rawValue }
}

struct ConsumerQuery: Identifiable {
    let id: String
    let consumerName: String
    let accountNumber: String
    let queryType: QueryType
    let message: String
    let submittedDate: Date

    init(
        id: String = UUID().uuidString,
        consumerName: String,
        accountNumber: String,
        queryType: QueryType,
        message: String,
        submittedDate: Date = Date()
    ) {
        self.id = id
        self.consumerName = consumerName
        self.accountNumber = accountNumber
        self.queryType = queryType
        self.message = message
        self.submittedDate = submittedDate
    }
}

enum QueryType: String, CaseIterable, Identifiable {
    case billInquiry = "Bill Inquiry"
    case connectionStatus = "Connection Status"
    case complaintStatus = "Complaint Status"
    case general = "General Inquiry"

    var id: String { rawValue }
}

extension SupportTicket {
    static let samples: [SupportTicket] = [
        SupportTicket(
            ticketNumber: "TKT-001234",
            consumerName: "Ramesh Patel",
            consumerContact: "+91 98765 43210",
            issueCategory: .powerOutage,
            priority: .urgent,
            status: .open,
            description:
                "Power outage in Sector 5 area since morning. Multiple consumers affected.",
            assignedTo: "Support Agent 1"
        ),
        SupportTicket(
            ticketNumber: "TKT-001235",
            consumerName: "Sunita Sharma",
            consumerContact: "+91 98765 43211",
            issueCategory: .billing,
            priority: .medium,
            status: .inProgress,
            description:
                "Discrepancy in November bill. Charged for 500 units but actual consumption was 350 units.",
            assignedTo: "Support Agent 2"
        ),
        SupportTicket(
            ticketNumber: "TKT-001236",
            consumerName: "Anil Kumar",
            consumerContact: "+91 98765 43212",
            issueCategory: .meterIssue,
            priority: .high,
            status: .resolved,
            description:
                "Meter display not working. Unable to read current consumption.",
            assignedTo: "Support Agent 1",
            resolvedDate: Calendar.current.date(
                byAdding: .day,
                value: -2,
                to: Date()
            )
        ),
    ]
}

extension FAQ {
    static let samples: [FAQ] = [
        FAQ(
            question: "How do I pay my electricity bill online?",
            answer:
                "You can pay your bill through the VoltHub app by navigating to Bills section and clicking 'Pay Bill'. We accept UPI, credit/debit cards, and net banking.",
            category: .billing
        ),
        FAQ(
            question: "What should I do if my meter is not working?",
            answer:
                "Please file a complaint through the app or call our support line. A technician will be assigned to resolve the issue within 24-48 hours.",
            category: .meters
        ),
        FAQ(
            question: "How long does it take to get a new connection?",
            answer:
                "New connection requests are typically processed within 7-10 business days after all required documents are submitted and verified.",
            category: .connection
        ),
        FAQ(
            question: "How can I track my complaint status?",
            answer:
                "You can track your complaint status in the Complaints section of the app. You'll receive real-time updates on the progress.",
            category: .complaints
        ),
    ]
}

extension KnowledgeArticle {
    static let samples: [KnowledgeArticle] = [
        KnowledgeArticle(
            title: "Understanding Your Electricity Bill",
            content:
                "Your bill includes fixed charges, energy charges based on consumption, and applicable taxes. Here's a detailed breakdown...",
            category: .howTo,
            views: 1234
        ),
        KnowledgeArticle(
            title: "Troubleshooting Common Meter Issues",
            content:
                "If your meter display is blank or showing errors, follow these steps: 1. Check the main switch... 2. Inspect for loose connections...",
            category: .troubleshooting,
            views: 856
        ),
        KnowledgeArticle(
            title: "Power Outage Reporting Guidelines",
            content:
                "To report a power outage: 1. Verify if it's a localized issue... 2. File a complaint with accurate location details...",
            category: .policies,
            views: 542
        ),
    ]
}

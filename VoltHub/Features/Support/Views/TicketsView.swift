import SwiftUI

struct TicketsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var tickets = SupportTicket.samples
    @State private var searchText = ""
    @State private var selectedStatus: TicketStatus?
    @State private var selectedPriority: TicketPriority?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search tickets...", text: $searchText)
                    .padding()
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter")
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            HStack {
                Text("\(filteredTickets.count) tickets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Ticket")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(themeManager.current.primary)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)

            if filteredTickets.isEmpty {
                EmptyStateView(
                    icon: "ticket",
                    message: "No tickets found",
                    description: "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTickets) { ticket in
                            TicketCard(ticket: ticket)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredTickets: [SupportTicket] {
        var result = tickets

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if let priority = selectedPriority {
            result = result.filter { $0.priority == priority }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.ticketNumber.localizedCaseInsensitiveContains(searchText)
                    || $0.consumerName.localizedCaseInsensitiveContains(
                        searchText
                    )
                    || $0.description.localizedCaseInsensitiveContains(
                        searchText
                    )
            }
        }

        return result.sorted { $0.submittedDate > $1.submittedDate }
    }
}

struct TicketCard: View {
    let ticket: SupportTicket
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ticket.ticketNumber)
                        .font(.headline)
                        .foregroundColor(themeManager.current.primary)

                    Text(ticket.consumerName)
                        .font(.subheadline)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    TicketStatusBadge(status: ticket.status)
                    TicketPriorityBadge(priority: ticket.priority)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.secondary)
                    Text(ticket.issueCategory.rawValue)
                        .font(.subheadline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.secondary)
                    Text(ticket.consumerContact)
                        .font(.subheadline)
                    Spacer()
                }

                if let assignedTo = ticket.assignedTo {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                        Text("Assigned to: \(assignedTo)")
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }

            Text(ticket.description)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .lineLimit(2)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text(ticket.submittedDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: {}) {
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.current.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct TicketStatusBadge: View {
    let status: TicketStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(6)
    }

    private var backgroundColor: Color {
        switch status {
        case .open:
            return .orange
        case .inProgress:
            return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .resolved:
            return .green
        case .closed:
            return .gray
        }
    }
}

struct TicketPriorityBadge: View {
    let priority: TicketPriority

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flag.fill")
            Text(priority.rawValue)
        }
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(6)
    }

    private var backgroundColor: Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .urgent:
            return .red
        }
    }
}

struct TicketFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? themeManager.current.primary
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(
                    isSelected ? themeManager.current.textOnPrimary : .primary
                )
                .cornerRadius(20)
        }
    }
}

#Preview {
    TicketsView()
        .environmentObject(ThemeManager())
}

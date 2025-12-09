import SwiftUI

struct SupportHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingDrawer = false
    @State private var selectedSection: SupportSection = .tickets

    var body: some View {
        ZStack {
            NavigationView {
                mainContent
                    .navigationTitle(selectedSection.rawValue)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation {
                                    showingDrawer.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(
                                        themeManager.current.primary
                                    )
                            }
                        }
                    }
            }

            if showingDrawer {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingDrawer = false
                        }
                    }

                HStack {
                    drawerMenu
                        .frame(width: 280)
                        .background(themeManager.current.background)
                        .transition(.move(edge: .leading))

                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        switch selectedSection {
        case .tickets:
            TicketsView()
        case .faqs:
            FAQsView()
        case .knowledgeBase:
            KnowledgeBaseView()
        case .queries:
            QueriesView()
        }
    }

    private var drawerMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "headphones.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(themeManager.current.primary)

                Text("VoltHub")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Support Portal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .padding(.top, 20)

            Divider()

            ScrollView {
                VStack(spacing: 4) {
                    ForEach(SupportSection.allCases, id: \.self) { section in
                        SupportMenuItem(
                            section: section,
                            isSelected: selectedSection == section,
                            action: {
                                selectedSection = section
                                withAnimation {
                                    showingDrawer = false
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text("Logged in as")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Support Agent")
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("Adani Client Team")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        }
    }
}

struct SupportMenuItem: View {
    let section: SupportSection
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.system(size: 20))
                    .foregroundColor(
                        isSelected ? themeManager.current.primary : .secondary
                    )
                    .frame(width: 24)

                Text(section.rawValue)
                    .font(.body)
                    .foregroundColor(
                        isSelected ? themeManager.current.primary : .primary
                    )

                Spacer()

                if isSelected {
                    Circle()
                        .fill(themeManager.current.primary)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                isSelected
                    ? themeManager.current.primary.opacity(0.1) : Color.clear
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum SupportSection: String, CaseIterable {
    case tickets = "Support Tickets"
    case faqs = "FAQs"
    case knowledgeBase = "Knowledge Base"
    case queries = "Consumer Queries"

    var icon: String {
        switch self {
        case .tickets:
            return "ticket.fill"
        case .faqs:
            return "questionmark.circle.fill"
        case .knowledgeBase:
            return "book.fill"
        case .queries:
            return "message.fill"
        }
    }
}

#Preview {
    SupportHomeView()
        .environmentObject(ThemeManager())
}

import SwiftUI

struct ConsumerHomeView: View {
    @EnvironmentObject private var theme: ThemeManager

    @State private var showSidebar: Bool = false
    @State private var selection: ConsumerSection? = .bills

    enum ConsumerSection: String, CaseIterable, Identifiable {
        case bills = "Bills"
        case newConnection = "Apply New Connection"
        case complaints = "Add Complaints"
        var id: String { rawValue }
    }

    @State private var searchText: String = ""
    @State private var bills: [Bill] = [
        .init(
            id: UUID(),
            accountNumber: "AC12345",
            description: "November Electricity Bill",
            amount: 92.40,
            dueDate: Date().addingTimeInterval(60 * 60 * 24 * 5),
            status: .unpaid
        ),
        .init(
            id: UUID(),
            accountNumber: "AC67890",
            description: "October Electricity Bill",
            amount: 101.10,
            dueDate: Date().addingTimeInterval(-60 * 60 * 24 * 5),
            status: .paid
        ),
        .init(
            id: UUID(),
            accountNumber: "AC13579",
            description: "September Electricity Bill",
            amount: 87.30,
            dueDate: Date().addingTimeInterval(-60 * 60 * 24 * 30),
            status: .paid
        ),
        .init(
            id: UUID(),
            accountNumber: "AC24680",
            description: "Adjustment Charge",
            amount: 12.15,
            dueDate: Date().addingTimeInterval(60 * 60 * 24 * 12),
            status: .unpaid
        ),
    ]

    private var filteredBills: [Bill] {
        bills.filter { bill in
            (searchText.isEmpty
                || bill.description.lowercased().contains(
                    searchText.lowercased()
                )
                || bill.accountNumber.lowercased().contains(
                    searchText.lowercased()
                ))
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .disabled(showSidebar)
                    .overlay(
                        Color.black.opacity(showSidebar ? 0.35 : 0).onTapGesture
                        { showSidebar = false }
                    )

                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(ConsumerSection.allCases) { section in
                            Button(action: {
                                selection = section
                                showSidebar = false
                            }) {
                                Text(section.rawValue)
                                    .font(.headline)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .background(
                                        selection == section
                                            ? theme.current.primary.opacity(
                                                0.15
                                            ) : Color.clear
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 8,
                                            style: .continuous
                                        )
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer()
                    }
                    .frame(width: 260)
                    .padding(.top, 44)
                    .padding(.horizontal, 6)
                    .background(Color(UIColor.systemGroupedBackground))
                    .offset(x: showSidebar ? 0 : -270)
                    .animation(.easeInOut(duration: 0.25), value: showSidebar)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSidebar.toggle() }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(theme.current.primary)
                    }
                }
            }
        }
    }

    @ViewBuilder private var contentView: some View {
        switch selection ?? .bills {
        case .bills: billsSection
        case .newConnection: newConnectionSection
        case .complaints: complaintsSection
        }
    }

    private var billsSection: some View {
        VStack(spacing: 18) {
            Text("Bills")
                .font(.largeTitle.bold())
                .foregroundColor(theme.current.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)

            BillsFilterBar(searchText: $searchText)

            ScrollView {
                LazyVStack(spacing: 14) {
                    if filteredBills.isEmpty {
                        Text("No bills found")
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    } else {
                        ForEach(filteredBills) { bill in
                            BillCard(bill: bill, onPay: { markBillPaid(bill) })
                                .environmentObject(theme)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }

    private func markBillPaid(_ bill: Bill) {
        guard let idx = bills.firstIndex(where: { $0.id == bill.id }) else {
            return
        }
        withAnimation(.easeInOut(duration: 0.25)) {
            bills[idx].status = .paid
        }
    }

    private var newConnectionSection: some View {
        NewConnectionFormView().environmentObject(theme)
    }

    private var complaintsSection: some View {
        ComplaintFormView().environmentObject(theme)
    }

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
}

struct ConsumerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerHomeView().environmentObject(ThemeManager())
    }
}

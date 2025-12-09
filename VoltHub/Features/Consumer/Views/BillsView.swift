import SwiftUI

struct BillsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    @State private var selectedFilter: BillStatus?
    @State private var bills = Bill.samples
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search bills...", text: $searchText)
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
            
            if filteredBills.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    message: "No bills found",
                    description: "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredBills) { bill in
                            BillCard(bill: bill, onPayTapped: {
                                handlePayBill(bill)
                            })
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private var filteredBills: [Bill] {
        var result = bills
        
        if let filter = selectedFilter {
            result = result.filter { $0.status == filter }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.accountNumber.localizedCaseInsensitiveContains(searchText) ||
                $0.meterID.localizedCaseInsensitiveContains(searchText) ||
                $0.billingPeriod.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.dueDate > $1.dueDate }
    }
    
    private func handlePayBill(_ bill: Bill) {
        print("Pay bill: \(bill.id)")
    }
}

struct BillFilterChip: View {
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
                .background(isSelected ? themeManager.current.primary : Color(red: 0.94, green: 0.95, blue: 0.96))
                .foregroundColor(isSelected ? themeManager.current.textOnPrimary : .primary)
                .cornerRadius(20)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let message: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.headline)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BillsView()
        .environmentObject(ThemeManager())
}

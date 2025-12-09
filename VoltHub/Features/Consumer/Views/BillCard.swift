import SwiftUI

struct BillCard: View {
    let bill: Bill
    let onPayTapped: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bill #\(bill.accountNumber)")
                        .font(.headline)
                    
                    Text("Meter ID: \(bill.meterID)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                BillStatusBadge(status: bill.status)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Amount Due")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("₹\(String(format: "%.2f", bill.amount))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.current.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Due Date")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(bill.dueDate, style: .date)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(dueInDays < 0 ? .red : (dueInDays < 3 ? .orange : .primary))
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    
                    Text(bill.billingPeriod)
                        .font(.subheadline)
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.secondary)
                    
                    Text("\(bill.unitsConsumed) kWh consumed")
                        .font(.subheadline)
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "gauge")
                        .foregroundColor(.secondary)
                    
                    Text("Previous: \(bill.previousReading) → Current: \(bill.currentReading)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            
            if bill.status == .unpaid || bill.status == .overdue {
                Button(action: onPayTapped) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                        
                        Text("Pay Bill")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.current.primary)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
    
    private var dueInDays: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: bill.dueDate).day ?? 0
    }
}

struct BillStatusBadge: View {
    let status: BillStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .paid:
            return .green
        case .unpaid:
            return .orange
        case .overdue:
            return .red
        }
    }
}

#Preview {
    BillCard(bill: Bill.samples[0], onPayTapped: {})
        .environmentObject(ThemeManager())
        .padding()
}

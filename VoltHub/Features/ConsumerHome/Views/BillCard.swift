import SwiftUI

struct BillCard: View {
    @EnvironmentObject private var theme: ThemeManager
    let bill: Bill
    var onPay: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bill.description)
                        .font(.headline)
                    Text("Account: \(bill.accountNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                statusBadge(bill.status)
            }
            HStack {
                Text("Amount:")
                    .font(.subheadline.weight(.semibold))
                Text("$" + String(format: "%.2f", bill.amount))
                Spacer()
                Text("Due: \(bill.dueDate, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if bill.status == .unpaid, let onPay {
                Button(action: onPay) {
                    Text("Pay Now")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 10,
                                style: .continuous
                            )
                        )
                }
                .buttonStyle(.plain)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else if bill.status == .paid {
                Text("Paid")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    private func statusBadge(_ status: BillStatus) -> some View {
        Text(status.rawValue.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                status == .unpaid
                    ? theme.current.primary.opacity(0.15)
                    : Color.green.opacity(0.15)
            )
            .foregroundColor(status == .unpaid ? theme.current.primary : .green)
            .clipShape(Capsule())
    }

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
}

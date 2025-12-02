import SwiftUI

struct ComplaintFormView: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var account: String = ""
    @State private var subject: String = ""
    @State private var bodyText: String = ""

    var body: some View {
        VStack(spacing: 22) {
            Text("Add Complaints")
                .font(.largeTitle.bold())
                .foregroundColor(theme.current.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            VStack(alignment: .leading, spacing: 16) {
                TextField("Account Number", text: $account)
                    .textFieldStyle(.roundedBorder)
                TextField("Subject", text: $subject)
                    .textFieldStyle(.roundedBorder)
                TextEditor(text: $bodyText)
                    .frame(height: 140)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                Button(action: {}) {
                    Text("Submit Complaint (Static)")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
            Spacer()
        }
        .padding(.horizontal)
    }
}

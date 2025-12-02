import SwiftUI

struct NewConnectionFormView: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var fullName: String = ""
    @State private var address: String = ""
    @State private var contact: String = ""

    var body: some View {
        VStack(spacing: 22) {
            Text("Apply New Connection")
                .font(.largeTitle.bold())
                .foregroundColor(theme.current.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            VStack(spacing: 16) {
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(.roundedBorder)
                TextField("Address", text: $address)
                    .textFieldStyle(.roundedBorder)
                TextField("Contact Number", text: $contact)
                    .textFieldStyle(.roundedBorder)
                Button(action: {}) {
                    Text("Submit (Static)")
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

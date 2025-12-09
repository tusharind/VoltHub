import SwiftUI

struct NewConnectionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    @State private var applicantName = ""
    @State private var address = ""
    @State private var contactNumber = ""
    @State private var emailAddress = ""
    @State private var connectionType: ConnectionType = .residential
    @State private var loadRequired = ""

    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSubmitting = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "bolt.badge.checkmark")
                                .font(.title)
                                .foregroundColor(themeManager.current.primary)

                            Text("New Connection Request")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Text(
                            "Fill in the details below to request a new electricity connection"
                        )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Personal Information")

                        FormField(
                            label: "Full Name",
                            icon: "person.fill",
                            text: $applicantName,
                            placeholder: "Enter your full name"
                        )

                        FormField(
                            label: "Address",
                            icon: "location.fill",
                            text: $address,
                            placeholder: "Enter complete address",
                            isMultiline: true
                        )

                        FormField(
                            label: "Contact Number",
                            icon: "phone.fill",
                            text: $contactNumber,
                            placeholder: "+91 XXXXX XXXXX",
                            keyboardType: .phonePad
                        )

                        FormField(
                            label: "Email Address",
                            icon: "envelope.fill",
                            text: $emailAddress,
                            placeholder: "your.email@example.com",
                            keyboardType: .emailAddress
                        )

                        Divider()
                            .padding(.vertical, 8)

                        SectionHeader(title: "Connection Details")

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Connection Type", systemImage: "house.fill")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Picker(
                                "Connection Type",
                                selection: $connectionType
                            ) {
                                ForEach(ConnectionType.allCases, id: \.self) {
                                    type in
                                    Text(type.rawValue.capitalized).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                        .cornerRadius(10)

                        FormField(
                            label: "Load Required (kW)",
                            icon: "bolt.fill",
                            text: $loadRequired,
                            placeholder: "e.g., 5",
                            keyboardType: .decimalPad
                        )

                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(
                                    Color(red: 0.2, green: 0.5, blue: 0.8)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Processing Time")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Text(
                                    "Your connection request will be processed within 7-10 business days. You will receive updates via SMS and email."
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1)
                        )
                        .cornerRadius(10)

                        Button(action: handleSubmit) {
                            HStack {
                                if isSubmitting {
                                    ProgressView()
                                        .progressViewStyle(
                                            CircularProgressViewStyle(
                                                tint: themeManager.current
                                                    .textOnPrimary
                                            )
                                        )
                                } else {
                                    Image(systemName: "paperplane.fill")

                                    Text("Submit Request")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                isFormValid
                                    ? themeManager.current.primary : Color.gray
                            )
                            .foregroundColor(themeManager.current.textOnPrimary)
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid || isSubmitting)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Connection Request", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("success") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private var isFormValid: Bool {
        !applicantName.isEmpty && !address.isEmpty && !contactNumber.isEmpty
            && !emailAddress.isEmpty && !loadRequired.isEmpty
            && contactNumber.count >= 10 && emailAddress.contains("@")
            && Double(loadRequired) != nil
    }

    private func handleSubmit() {
        guard isFormValid else { return }

        isSubmitting = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            alertMessage =
                "Your connection request has been submitted successfully. You will receive a confirmation email shortly."
            showingAlert = true
        }
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
    }
}

struct FormField: View {
    let label: String
    let icon: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(label, systemImage: icon)
                .font(.subheadline)
                .fontWeight(.medium)

            if isMultiline {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(
                        keyboardType == .emailAddress ? .never : .words
                    )
                    .padding()
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    NewConnectionView()
        .environmentObject(ThemeManager())
}

//

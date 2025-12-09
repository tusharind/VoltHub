import SwiftUI

struct ComplaintsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    @State private var subject = ""
    @State private var description = ""
    @State private var category: ComplaintCategory = .other
    @State private var priority: ComplaintPriority = .medium

    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSubmitting = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.bubble")
                                .font(.title)
                                .foregroundColor(themeManager.current.primary)

                            Text("File a Complaint")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Text(
                            "Report any issues or concerns with your electricity service"
                        )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 20) {
                        FormField(
                            label: "Subject",
                            icon: "text.alignleft",
                            text: $subject,
                            placeholder: "Brief summary of your complaint"
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Description", systemImage: "text.justify")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            TextEditor(text: $description)
                                .frame(height: 150)
                                .padding(8)
                                .background(
                                    Color(red: 0.96, green: 0.97, blue: 0.98)
                                )
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            Color(.systemGray4),
                                            lineWidth: 1
                                        )
                                )

                            if description.isEmpty {
                                Text("Describe your issue in detail")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .offset(y: -145)
                                    .padding(.leading, 12)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Category", systemImage: "folder.fill")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Picker("Category", selection: $category) {
                                ForEach(ComplaintCategory.allCases, id: \.self)
                                { cat in
                                    HStack {
                                        Image(systemName: categoryIcon(cat))
                                        Text(categoryLabel(cat))
                                    }.tag(cat)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding()
                            .background(
                                Color(red: 0.96, green: 0.97, blue: 0.98)
                            )
                            .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Priority", systemImage: "flag.fill")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Picker("Priority", selection: $priority) {
                                ForEach(ComplaintPriority.allCases, id: \.self)
                                { prio in
                                    HStack {
                                        Circle()
                                            .fill(priorityColor(prio))
                                            .frame(width: 10, height: 10)
                                        Text(prio.rawValue.capitalized)
                                    }.tag(prio)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                        .cornerRadius(10)

                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.orange)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Response Time")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Text(
                                    "We typically respond to complaints within 24-48 hours. Urgent issues are prioritized and addressed immediately."
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Common Issues")
                                .font(.headline)

                            ForEach(commonIssues, id: \.self) { issue in
                                Button(action: {
                                    setQuickComplaint(issue)
                                }) {
                                    HStack {
                                        Image(
                                            systemName: "lightbulb.circle.fill"
                                        )
                                        .foregroundColor(
                                            themeManager.current.primary
                                        )

                                        Text(issue)
                                            .font(.subheadline)

                                        Spacer()

                                        Image(systemName: "arrow.right.circle")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(
                                        Color(
                                            red: 0.96,
                                            green: 0.97,
                                            blue: 0.98
                                        )
                                    )
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

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

                                    Text("Submit Complaint")
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
            .alert("Complaint Status", isPresented: $showingAlert) {
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

    private let commonIssues = [
        "Frequent power cuts",
        "High electricity bill",
        "Meter not working",
        "Voltage fluctuation",
    ]

    private var isFormValid: Bool {
        !subject.isEmpty && !description.isEmpty && description.count >= 20
    }

    private func categoryIcon(_ category: ComplaintCategory) -> String {
        switch category {
        case .billing:
            return "dollarsign.circle"
        case .powerOutage:
            return "bolt.slash"
        case .meterIssue:
            return "gauge"
        case .qualityIssue:
            return "waveform.path.ecg"
        case .other:
            return "ellipsis.circle"
        }
    }

    private func categoryLabel(_ category: ComplaintCategory) -> String {
        switch category {
        case .billing:
            return "Billing"
        case .powerOutage:
            return "Power Outage"
        case .meterIssue:
            return "Meter Issue"
        case .qualityIssue:
            return "Quality Issue"
        case .other:
            return "Other"
        }
    }

    private func priorityColor(_ priority: ComplaintPriority) -> Color {
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

    private func setQuickComplaint(_ issue: String) {
        subject = issue
        description = "I am experiencing issues with \(issue.lowercased()). "

        if issue.contains("power cuts") {
            category = .powerOutage
            priority = .high
        } else if issue.contains("bill") {
            category = .billing
            priority = .medium
        } else if issue.contains("meter") {
            category = .meterIssue
            priority = .high
        } else if issue.contains("voltage") {
            category = .qualityIssue
            priority = .high
        }
    }

    private func handleSubmit() {
        guard isFormValid else { return }

        isSubmitting = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            alertMessage =
                "Your complaint has been submitted successfully. Reference ID: #\(Int.random(in: 1000...9999))"
            showingAlert = true
        }
    }
}

#Preview {
    ComplaintsView()
        .environmentObject(ThemeManager())
}

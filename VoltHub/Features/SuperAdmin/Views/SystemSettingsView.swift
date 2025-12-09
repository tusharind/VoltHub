import SwiftUI

struct SystemSettingsView: View {
    @State private var selectedCategory: SettingCategory = .billing

    var body: some View {
        VStack(spacing: 0) {
            HStack {
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
                Spacer()
            }
            .padding()
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))

            ScrollView {
                VStack(spacing: 20) {
                    switch selectedCategory {
                    case .billing:
                        BillingSettingsSection()
                    case .operations:
                        OperationsSettingsSection()
                    case .security:
                        SecuritySettingsSection()
                    case .notifications:
                        NotificationsSettingsSection()
                    case .integrations:
                        IntegrationsSettingsSection()
                    }
                }
                .padding()
            }
        }
    }
}

struct SettingCategoryChip: View {
    let category: SettingCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: categoryIcon)
                Text(category.rawValue)
            }
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? Color(red: 0.2, green: 0.5, blue: 0.8)
                    : Color(red: 0.94, green: 0.95, blue: 0.96)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }

    private var categoryIcon: String {
        switch category {
        case .billing: return "indianrupeesign.circle.fill"
        case .operations: return "gearshape.fill"
        case .security: return "lock.shield.fill"
        case .notifications: return "bell.fill"
        case .integrations: return "link.circle.fill"
        }
    }
}

struct BillingSettingsSection: View {
    @State private var autoBillingEnabled = true
    @State private var lateFeeEnabled = true
    @State private var gracePeriodDays = "7"
    @State private var lateFeePercentage = "2.0"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Billing Configuration")
                .font(.title3)
                .fontWeight(.bold)

            SettingCard {
                VStack(spacing: 16) {
                    SettingToggleRow(
                        icon: "calendar.badge.clock",
                        title: "Automatic Billing",
                        description:
                            "Generate bills automatically on cycle date",
                        isOn: $autoBillingEnabled
                    )

                    Divider()

                    SettingToggleRow(
                        icon: "exclamationmark.circle",
                        title: "Late Fee Charges",
                        description: "Apply late fees for overdue payments",
                        isOn: $lateFeeEnabled
                    )

                }
            }

            //            SettingCard {
            //                VStack(spacing: 16) {
            //                    SettingToggleRow(
            //                        icon: "creditcard",
            //                        title: "Online Payment Gateway",
            //                        description: "Enable digital payment methods",
            //                        isOn: .constant(true)
            //                    )
            //
            //                    Divider()
            //
            //                    SettingToggleRow(
            //                        icon: "doc.text",
            //                        title: "E-Bill Generation",
            //                        description: "Send bills via email and SMS",
            //                        isOn: .constant(true)
            //                    )
            //                }
            //            }
        }
    }
}

struct OperationsSettingsSection: View {
    @State private var autoAssignTasks = true
    @State private var maintenanceMode = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Operations Configuration")
                .font(.title3)
                .fontWeight(.bold)

            SettingCard {
                VStack(spacing: 16) {
                    SettingToggleRow(
                        icon: "arrow.triangle.branch",
                        title: "Auto Task Assignment",
                        description:
                            "Automatically assign tasks to available workers",
                        isOn: $autoAssignTasks
                    )

                    Divider()

                    SettingToggleRow(
                        icon: "exclamationmark.triangle",
                        title: "Maintenance Mode",
                        description:
                            "Restrict access during system maintenance",
                        isOn: $maintenanceMode
                    )
                }
            }
            //
            //            SettingCard {
            //                VStack(spacing: 16) {
            //                    SettingActionRow(
            //                        icon: "arrow.clockwise",
            //                        title: "Sync All Data",
            //                        description: "Synchronize data across all districts",
            //                        actionTitle: "Sync Now"
            //                    )
            //
            //                    Divider()
            //
            //                    SettingActionRow(
            //                        icon: "trash",
            //                        title: "Clear Cache",
            //                        description: "Remove temporary system cache",
            //                        actionTitle: "Clear"
            //                    )
            //                }
            //            }
        }
    }
}

struct SecuritySettingsSection: View {
    @State private var twoFactorAuth = true
    @State private var sessionTimeout = "30"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Security Configuration")
                .font(.title3)
                .fontWeight(.bold)

            SettingCard {
                VStack(spacing: 16) {
                    SettingToggleRow(
                        icon: "lock.shield",
                        title: "Two-Factor Authentication",
                        description: "Require 2FA for all admin accounts",
                        isOn: $twoFactorAuth
                    )

                    Divider()

                    //                    SettingInputRow(
                    //                        icon: "clock",
                    //                        title: "Session Timeout",
                    //                        value: $sessionTimeout,
                    //                        suffix: "minutes"
                    //                    )
                }
            }

            //            SettingCard {
            //                VStack(spacing: 16) {
            //                    SettingActionRow(
            //                        icon: "key",
            //                        title: "Reset All Passwords",
            //                        description: "Force password reset for all users",
            //                        actionTitle: "Reset"
            //                    )
            //
            //                    Divider()
            //
            //                    SettingActionRow(
            //                        icon: "doc.text.magnifyingglass",
            //                        title: "View Audit Logs",
            //                        description: "Access system activity logs",
            //                        actionTitle: "View"
            //                    )
            //                }
            //            }
        }
    }
}

struct NotificationsSettingsSection: View {
    @State private var pushNotifications = true
    @State private var emailNotifications = true
    @State private var smsNotifications = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notification Configuration")
                .font(.title3)
                .fontWeight(.bold)

            SettingCard {
                VStack(spacing: 16) {
                    SettingToggleRow(
                        icon: "bell.badge",
                        title: "Push Notifications",
                        description: "Send in-app notifications",
                        isOn: $pushNotifications
                    )

                    Divider()

                    SettingToggleRow(
                        icon: "envelope",
                        title: "Email Notifications",
                        description: "Send email alerts",
                        isOn: $emailNotifications
                    )

                    Divider()

                    SettingToggleRow(
                        icon: "message",
                        title: "SMS Notifications",
                        description: "Send SMS alerts for critical events",
                        isOn: $smsNotifications
                    )
                }
            }
        }
    }
}

struct IntegrationsSettingsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Integration Configuration")
                .font(.title3)
                .fontWeight(.bold)

            SettingCard {
                VStack(spacing: 16) {
                    SettingToggleRow(
                        icon: "cloud",
                        title: "Cloud Backup",
                        description: "Automatic cloud backup enabled",
                        isOn: .constant(true)
                    )

                    Divider()

                    SettingToggleRow(
                        icon: "chart.bar.xaxis",
                        title: "Analytics Integration",
                        description: "Send data to analytics platform",
                        isOn: .constant(true)
                    )
                }
            }

            //            SettingCard {
            //                VStack(spacing: 16) {
            //                    SettingActionRow(
            //                        icon: "link",
            //                        title: "API Configuration",
            //                        description: "Manage external API integrations",
            //                        actionTitle: "Configure"
            //                    )
            //
            //                    Divider()
            //
            //                    SettingActionRow(
            //                        icon: "key",
            //                        title: "API Keys",
            //                        description: "View and manage API keys",
            //                        actionTitle: "Manage"
            //                    )
            //                }

        }
    }
}

struct SettingCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
            .cornerRadius(12)
    }
}

struct SettingToggleRow: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct SettingTextFieldRow: View {
    let icon: String
    let title: String
    @Binding var value: String
    let suffix: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .frame(width: 30)

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)

            Spacer()

            HStack {
                TextField("", text: $value)
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Text(suffix)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct SettingButtonRow: View {
    let icon: String
    let title: String
    let description: String
    let actionTitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {}) {
                Text(actionTitle)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.2, green: 0.5, blue: 0.8))
                    .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    SystemSettingsView()
}

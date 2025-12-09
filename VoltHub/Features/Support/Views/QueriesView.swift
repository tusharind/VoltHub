import SwiftUI

struct QueriesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var queries: [ConsumerQuery] = []
    @State private var searchText = ""
    @State private var selectedType: QueryType?
    @State private var showingNewQueryForm = false

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search queries...", text: $searchText)
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

            HStack {
                Text("\(filteredQueries.count) queries")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: { showingNewQueryForm = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Query")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(themeManager.current.primary)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)

            if filteredQueries.isEmpty {
                EmptyStateView(
                    icon: "message",
                    message: "No queries found",
                    description: queries.isEmpty
                        ? "No consumer queries received yet"
                        : "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredQueries) { query in
                            QueryCard(query: query)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .sheet(isPresented: $showingNewQueryForm) {
            NewQueryFormView()
        }
    }

    private var filteredQueries: [ConsumerQuery] {
        var result = queries

        if let type = selectedType {
            result = result.filter { $0.queryType == type }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.consumerName.localizedCaseInsensitiveContains(searchText)
                    || $0.accountNumber.localizedCaseInsensitiveContains(
                        searchText
                    ) || $0.message.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result.sorted { $0.submittedDate > $1.submittedDate }
    }
}

struct QueryCard: View {
    let query: ConsumerQuery
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(query.consumerName)
                        .font(.headline)

                    Text("Account: \(query.accountNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(query.queryType.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(themeManager.current.primary.opacity(0.2))
                    .foregroundColor(themeManager.current.primary)
                    .cornerRadius(6)
            }

            Divider()

            Text(query.message)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.3, green: 0.4, blue: 0.5))
                .lineLimit(3)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text(query.submittedDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                        Text("Respond")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.current.textOnPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(themeManager.current.primary)
                    .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct QueryFilterChip: View {
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
                .background(
                    isSelected
                        ? themeManager.current.primary
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(
                    isSelected ? themeManager.current.textOnPrimary : .primary
                )
                .cornerRadius(20)
        }
    }
}

struct NewQueryFormView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    @State private var consumerName = ""
    @State private var accountNumber = ""
    @State private var queryType: QueryType = .general
    @State private var message = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Consumer Details")) {
                    TextField("Consumer Name", text: $consumerName)
                    TextField("Account Number", text: $accountNumber)
                }

                Section(header: Text("Query Details")) {
                    Picker("Query Type", selection: $queryType) {
                        ForEach(QueryType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }

                    TextEditor(text: $message)
                        .frame(height: 150)
                }

                Section {
                    Button(action: handleSubmit) {
                        Text("Submit Query")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(themeManager.current.primary)
                    }
                }
            }
            .navigationTitle("New Consumer Query")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func handleSubmit() {
        dismiss()
    }
}

#Preview {
    QueriesView()
        .environmentObject(ThemeManager())
}

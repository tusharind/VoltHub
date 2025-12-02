import SwiftUI

struct WorkerFilterBar: View {
    @EnvironmentObject private var theme: ThemeManager
    @Binding var searchText: String
    @Binding var selectedFilter: TaskType?

    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search tasks", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Menu {
                Button("All") { selectedFilter = nil }
                ForEach(TaskType.allCases) { t in
                    Button(action: { selectedFilter = t }) {
                        Label(
                            t.rawValue,
                            systemImage: selectedFilter == t ? "checkmark" : ""
                        )
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text(selectedFilter?.rawValue ?? "All")
                }
                .font(.subheadline)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            }
            .tint(theme.current.primary)
        }
    }
}

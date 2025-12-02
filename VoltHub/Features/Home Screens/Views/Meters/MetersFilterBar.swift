import SwiftUI

struct MetersFilterBar: View {
    @EnvironmentObject private var theme: ThemeManager
    @Binding var searchText: String
    @Binding var selectedFilter: MeterFilter

    enum MeterFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case active = "Active"
        case inactive = "Inactive"
        var id: String { rawValue }
    }

    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search meters", text: $searchText)
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
                ForEach(MeterFilter.allCases) { f in
                    Button(action: { selectedFilter = f }) {
                        Label(
                            f.rawValue,
                            systemImage: selectedFilter == f ? "checkmark" : ""
                        )
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text(selectedFilter.rawValue)
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

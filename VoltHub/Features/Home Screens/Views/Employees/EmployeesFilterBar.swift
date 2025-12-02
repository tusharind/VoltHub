import SwiftUI

struct EmployeesFilterBar: View {
    @Binding var searchText: String
    @Binding var selectedFilter: EmployeeFilter
    @EnvironmentObject private var theme: ThemeManager

    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search employees", text: $searchText)
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
                ForEach(EmployeeFilter.allCases) { f in
                    Button(action: { selectedFilter = f }) {
                        Label(f.rawValue, systemImage: selectedFilter == f ? "checkmark" : "")
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
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .tint(theme.current.primary)
        }
    }
}

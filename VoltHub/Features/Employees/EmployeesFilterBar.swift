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
            .background(Color(red: 0.96, green: 0.97, blue: 0.98))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

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
    }
}

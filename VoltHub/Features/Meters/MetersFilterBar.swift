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

import SwiftUI

struct OperationsFilterBar: View {
    @Binding var searchText: String
    var level: OpsLevel

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(
                "Search \(level.rawValue.lowercased())",
                text: $searchText
            )
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
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

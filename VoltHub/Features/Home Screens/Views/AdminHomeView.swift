import SwiftUI

struct AdminHomeView: View {

    @State private var showSidebar = false
    @State private var selection: SidebarOption? = .home

    enum SidebarOption: String, CaseIterable, Identifiable {
        case home = "Home"
        case employees = "Employees"

        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            ZStack {

                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .disabled(showSidebar)
                    .overlay(

                        Color.black.opacity(showSidebar ? 0.4 : 0)
                            .onTapGesture { showSidebar = false }
                    )

                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(SidebarOption.allCases) { option in
                            Button(action: {
                                selection = option
                                showSidebar = false
                            }) {
                                Text(option.rawValue)
                                    .font(.headline)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .background(
                                        selection == option
                                            ? Color.gray.opacity(0.2)
                                            : Color.clear
                                    )
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        Spacer()
                    }
                    .frame(width: 250)
                    .padding(.top, 40)
                    .background(Color(UIColor.systemGroupedBackground))
                    .offset(x: showSidebar ? 0 : -250)
                    .animation(.easeInOut(duration: 0.25), value: showSidebar)

                    Spacer()
                }

                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showSidebar.toggle() }) {
                            Image(systemName: "line.horizontal.3")
                        }
                    }
                }

            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch selection {
        case .home, .none:
            Text("Admin Home")
                .font(.largeTitle)
                .foregroundColor(.secondary)
        case .employees:
            AddEmployeeView(currentUserRole: .Admin)
        }
    }
}

struct AdminHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AdminHomeView()
    }
}

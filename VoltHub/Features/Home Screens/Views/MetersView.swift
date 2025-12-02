import SwiftUI

struct MetersView: View {
    @EnvironmentObject private var theme: ThemeManager
    @State private var searchText = ""
    @State private var selectedFilter: MetersFilterBar.MeterFilter = .all
    @State private var showAddMeter = false
    @State private var showEditMeter: Meter? = nil
    @State private var showDeleteConfirm: Meter? = nil

    @State private var meters: [Meter] = [
        .init(
            id: UUID(),
            name: "Main Grid Meter",
            type: .electric,
            status: .active
        ),
        .init(
            id: UUID(),
            name: "Basement Flow",
            type: .water,
            status: .inactive
        ),
        .init(
            id: UUID(),
            name: "Solar Array #1",
            type: .electric,
            status: .active
        ),
        .init(id: UUID(), name: "Cooling Loop", type: .gas, status: .active),
    ]

    private var filteredMeters: [Meter] {
        meters.filter { meter in
            (selectedFilter == .all
                || (selectedFilter == .active && meter.status == .active)
                || (selectedFilter == .inactive && meter.status == .inactive))
                && (searchText.isEmpty
                    || meter.name.lowercased().contains(searchText.lowercased()))
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            MetersHeader()
            MetersFilterBar(
                searchText: $searchText,
                selectedFilter: $selectedFilter
            )
            ScrollView {
                LazyVStack(spacing: 12) {
                    if filteredMeters.isEmpty {
                        Text("No meters found")
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    } else {
                        ForEach(filteredMeters) { meter in
                            MeterCard(
                                meter: meter,
                                onEdit: { showEditMeter = meter },
                                onDelete: { showDeleteConfirm = meter }
                            )
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .sheet(isPresented: $showAddMeter) {
            MeterFormView(mode: .add, isPresented: $showAddMeter)
                .environmentObject(theme)
        }
        .sheet(item: $showEditMeter) { meter in
            let binding = Binding<Bool>(
                get: { showEditMeter != nil },
                set: { value in if !value { showEditMeter = nil } }
            )
            MeterFormView(mode: .edit(meter), isPresented: binding)
                .environmentObject(theme)
        }
        .alert(item: $showDeleteConfirm) { meter in
            Alert(
                title: Text("Delete Meter"),
                message: Text("This is static UI only."),
                primaryButton: .destructive(Text("Delete")) {
                    showDeleteConfirm = nil
                },
                secondaryButton: .cancel { showDeleteConfirm = nil }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddMeter = true }) {
                    Image(systemName: "plus")
                        .imageScale(.medium)
                        .padding(6)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Add Meter")
            }
        }
    }
}

#Preview {
    let container = AppContainer()
    return NavigationStack {
        MetersView().environmentObject(container.themeManager)
    }
}

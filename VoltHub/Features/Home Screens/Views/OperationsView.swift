import SwiftUI

struct OperationsView: View {
    @EnvironmentObject private var theme: ThemeManager

    @State private var level: OpsLevel = .states

    @State private var searchText: String = ""
    @State private var showAddSheet: Bool = false
    @State private var editItem: OperationEntity? = nil
    @State private var deleteConfirm: OperationEntity? = nil

    @State private var states: [OperationState] = [
        .init(id: UUID(), name: "California", head: "Alice Kim"),
        .init(id: UUID(), name: "Texas", head: "Bob Jones"),
        .init(id: UUID(), name: "New York", head: "Carol Smith"),
    ]
    @State private var districts: [OperationDistrict] = [
        .init(id: UUID(), name: "Orange County", head: "Derek Wu"),
        .init(id: UUID(), name: "Harris District", head: "Emily Ford"),
        .init(id: UUID(), name: "Queens District", head: "Frank Lee"),
    ]
    @State private var cities: [OperationCity] = [
        .init(id: UUID(), name: "Los Angeles", head: "Grace Chen"),
        .init(id: UUID(), name: "Houston", head: "Henry Park"),
        .init(id: UUID(), name: "New York City", head: "Irene Patel"),
    ]

    private var filteredStates: [OperationState] {
        states.filter { searchMatch($0.name) }
    }
    private var filteredDistricts: [OperationDistrict] {
        districts.filter { searchMatch($0.name) }
    }
    private var filteredCities: [OperationCity] {
        cities.filter { searchMatch($0.name) }
    }

    private func searchMatch(_ value: String) -> Bool {
        searchText.isEmpty
            || value.lowercased().contains(searchText.lowercased())
    }

    var body: some View {
        VStack(spacing: 18) {
            OperationsHeader(level: $level)
                .environmentObject(theme)

            OperationsFilterBar(searchText: $searchText, level: level)

            ScrollView {
                LazyVStack(spacing: 14) {
                    switch level {
                    case .states:
                        entitySection(
                            filteredStates.map { OperationEntity.state($0) }
                        )
                    case .districts:
                        entitySection(
                            filteredDistricts.map {
                                OperationEntity.district($0)
                            }
                        )
                    case .cities:
                        entitySection(
                            filteredCities.map { OperationEntity.city($0) }
                        )
                    }
                }
                .padding(.vertical, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .sheet(isPresented: $showAddSheet) { addSheet }
        .sheet(item: $editItem) { item in
            editSheet(item)
        }
        .alert(item: $deleteConfirm) { item in
            Alert(
                title: Text("Delete \(item.title)"),
                message: Text("Static UI only."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteConfirm = nil
                },
                secondaryButton: .cancel { deleteConfirm = nil }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus")
                        .imageScale(.medium)
                        .padding(6)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Add Operation Entity")
            }
        }
    }

    private func entitySection(_ items: [OperationEntity]) -> some View {
        Group {
            if items.isEmpty {
                Text("No \(level.rawValue.lowercased()) found")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            } else {
                ForEach(items) { item in
                    OperationCard(
                        item: item,
                        onEdit: { editItem = $0 },
                        onDelete: { deleteConfirm = $0 }
                    )
                    .environmentObject(theme)
                }
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            OperationEntityFormView(
                mode: .add(level),
                isPresented: $showAddSheet
            ) { newEntity in
                switch newEntity {
                case .state(let st): states.append(st)
                case .district(let d): districts.append(d)
                case .city(let c): cities.append(c)
                }
            }
            .environmentObject(theme)
        }
    }

    private func editSheet(_ item: OperationEntity) -> some View {
        let binding = Binding<Bool>(
            get: { editItem != nil },
            set: { v in if !v { editItem = nil } }
        )
        return NavigationStack {
            OperationEntityFormView(mode: .edit(item), isPresented: binding) {
                updated in
                switch updated {
                case .state(let st):
                    if let idx = states.firstIndex(where: { $0.id == st.id }) {
                        states[idx] = st
                    }
                case .district(let d):
                    if let idx = districts.firstIndex(where: { $0.id == d.id })
                    {
                        districts[idx] = d
                    }
                case .city(let c):
                    if let idx = cities.firstIndex(where: { $0.id == c.id }) {
                        cities[idx] = c
                    }
                }
            }
            .environmentObject(theme)
        }
    }
}

struct OperationsView_Previews: PreviewProvider {
    static var previews: some View {
        OperationsView().environmentObject(ThemeManager())
    }
}

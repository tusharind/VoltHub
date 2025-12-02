import SwiftUI

struct WorkersHomeView: View {
    @EnvironmentObject private var theme: ThemeManager

    @State private var tasks: [WorkerTask] = [
        .init(
            id: UUID(),
            title: "Reading - Sector 12",
            description: "Record current consumption for meter SN-221.",
            type: .reading,
            status: .pending,
            meterId: "SN-221"
        ),
        .init(
            id: UUID(),
            title: "Install - New Apartment",
            description: "Install smart meter at Block B, Flat 304.",
            type: .install,
            status: .pending,
            meterId: "NEW-304"
        ),
        .init(
            id: UUID(),
            title: "Reading - Industrial Park",
            description: "Monthly reading for heavy usage meter HX-77.",
            type: .reading,
            status: .completed,
            meterId: "HX-77"
        ),
        .init(
            id: UUID(),
            title: "Install - Replacement",
            description: "Replace faulty meter at store front ST-19.",
            type: .install,
            status: .pending,
            meterId: "ST-19"
        ),
    ]

    @State private var searchText: String = ""
    @State private var selectedFilter: TaskType? = nil
    @State private var selectedTask: WorkerTask? = nil

    private var filteredTasks: [WorkerTask] {
        tasks.filter { task in
            (selectedFilter == nil || task.type == selectedFilter)
                && (searchText.isEmpty
                    || task.title.lowercased().contains(searchText.lowercased())
                    || (task.meterId ?? "").lowercased().contains(
                        searchText.lowercased()
                    ))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Text("My Tasks")
                    .font(.largeTitle.bold())
                    .foregroundColor(theme.current.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)

                WorkerFilterBar(
                    searchText: $searchText,
                    selectedFilter: $selectedFilter
                )
                .environmentObject(theme)

                ScrollView {
                    LazyVStack(spacing: 14) {
                        if filteredTasks.isEmpty {
                            Text("No tasks found")
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                        } else {
                            ForEach(filteredTasks) { task in
                                WorkerTaskCard(
                                    task: task,
                                    onView: { selectedTask = $0 },
                                    onQuickComplete: { markComplete($0) }
                                )
                                .environmentObject(theme)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .sheet(item: $selectedTask) { task in
                WorkerTaskDetailSheet(
                    task: task,
                    tasks: $tasks,
                    isPresented: Binding<Bool>(
                        get: { selectedTask != nil },
                        set: { v in if !v { selectedTask = nil } }
                    )
                )
                .environmentObject(theme)
            }
        }
    }

    private func markComplete(_ task: WorkerTask) {
        guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        withAnimation(.easeInOut(duration: 0.25)) {
            tasks[idx].status = .completed
        }
    }
}

struct WorkersHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkersHomeView().environmentObject(ThemeManager())
    }
}

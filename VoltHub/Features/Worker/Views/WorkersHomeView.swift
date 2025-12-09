import SwiftUI

struct WorkersHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State private var tasks: [WorkerTask] = WorkerTask.samples
    @State private var searchText = ""
    @State private var selectedFilter: TaskType?
    @State private var selectedTask: WorkerTask?
    @State private var showingTaskDetail = false

    var filteredTasks: [WorkerTask] {
        var filtered = tasks

        if let type = selectedFilter {
            filtered = filtered.filter { $0.type == type }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText)
                    || task.description.localizedCaseInsensitiveContains(
                        searchText
                    )
                    || (task.meterID?.localizedCaseInsensitiveContains(
                        searchText
                    ) ?? false)
            }
        }

        return filtered
    }

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.current.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)

                        TextField("Search tasks...", text: $searchText)
                            .foregroundColor(
                                Color(red: 0.3, green: 0.4, blue: 0.5)
                            )
                    }
                    .padding()
                    .background(Color(red: 0.94, green: 0.95, blue: 0.96))
                    .cornerRadius(10)
                    .padding()

                    // Filter Bar
                    HStack {
                        Button(action: {}) {
                            HStack {
                                Image(
                                    systemName:
                                        "line.3.horizontal.decrease.circle"
                                )
                                Text("Filter")
                            }
                            .font(.subheadline)
                            .foregroundColor(
                                Color(red: 0.3, green: 0.4, blue: 0.5)
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Color(red: 0.96, green: 0.97, blue: 0.98)
                            )
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    if filteredTasks.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary.opacity(0.5))

                            Text("No tasks found")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            if !searchText.isEmpty {
                                Text("Try adjusting your search")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary.opacity(0.7))
                            }
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredTasks) { task in
                                    WorkerTaskCard(
                                        task: task,
                                        theme: themeManager.current
                                    ) {
                                        selectedTask = task
                                        showingTaskDetail = true
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingTaskDetail) {
                if let task = selectedTask,
                    let index = tasks.firstIndex(where: { $0.id == task.id })
                {
                    WorkerTaskDetailSheet(
                        task: $tasks[index],
                        theme: themeManager.current,
                        onDismiss: {
                            showingTaskDetail = false
                        }
                    )
                    .environmentObject(themeManager)
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let theme: Theme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? theme.primary
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(isSelected ? theme.textOnPrimary : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    WorkersHomeView()
        .environmentObject(ThemeManager())
}

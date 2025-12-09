import SwiftUI

struct WorkersView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var workers = Worker.samples
    @State private var searchText = ""
    @State private var selectedStatus: WorkerStatus?

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                TextField("Search workers...", text: $searchText)
                    .padding()
                    .background(Color(red: 0.96, green: 0.97, blue: 0.98))
                    .cornerRadius(10)

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
            .padding(.horizontal)

            if filteredWorkers.isEmpty {
                EmptyStateView(
                    icon: "person.3",
                    message: "No workers found",
                    description: "Try adjusting your filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredWorkers) { worker in
                            WorkerCard(worker: worker)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }

    private var filteredWorkers: [Worker] {
        var result = workers

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                    || $0.employeeID.localizedCaseInsensitiveContains(
                        searchText
                    )
                    || $0.assignedArea.localizedCaseInsensitiveContains(
                        searchText
                    )
            }
        }

        return result
    }
}

struct WorkerCard: View {
    let worker: Worker
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(themeManager.current.primary)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(worker.name.prefix(1))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(worker.name)
                        .font(.headline)

                    Text(worker.employeeID)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                WorkerStatusBadge(status: worker.status)
            }

            Divider()

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.secondary)
                    Text(worker.contactNumber)
                        .font(.subheadline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(.secondary)
                    Text(worker.assignedArea)
                        .font(.subheadline)
                    Spacer()
                }
            }

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(worker.tasksCompleted)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("In Progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(worker.tasksInProgress)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(red: 0.96, green: 0.97, blue: 0.98))
        .cornerRadius(12)
    }
}

struct WorkerStatusBadge: View {
    let status: WorkerStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }

    private var backgroundColor: Color {
        switch status {
        case .active:
            return .green
        case .onLeave:
            return .orange
        case .inactive:
            return .gray
        }
    }
}

struct WorkerFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? themeManager.current.primary
                        : Color(red: 0.94, green: 0.95, blue: 0.96)
                )
                .foregroundColor(
                    isSelected ? themeManager.current.textOnPrimary : .primary
                )
                .cornerRadius(20)
        }
    }
}

#Preview {
    WorkersView()
        .environmentObject(ThemeManager())
}

import PhotosUI
import SwiftUI

struct WorkerTaskDetailSheet: View {
    @EnvironmentObject private var theme: ThemeManager
    let task: WorkerTask
    @Binding var tasks: [WorkerTask]
    @Binding var isPresented: Bool

    @State private var comment: String = ""
    @State private var pickedItems: [PhotosPickerItem] = []
    @State private var images: [Image] = []

    var body: some View {
        VStack(spacing: 20) {
            Text(task.title)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(task.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let meterId = task.meterId {
                Text("Meter ID: \(meterId)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            statusRow
            photosSection
            commentsSection
            Spacer()
            actionButtons
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { isPresented = false }
            }
        }
        .onChange(of: pickedItems) { oldItems, newItems in
            loadImages(from: newItems)
        }
    }

    private var statusRow: some View {
        HStack {
            Text("Status:")
                .font(.subheadline.weight(.semibold))
            statusBadge(task.status)
            Spacer()
        }
    }

    private func statusBadge(_ status: TaskStatus) -> some View {
        Text(status.rawValue.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                status == .pending
                    ? theme.current.primary.opacity(0.15)
                    : Color.green.opacity(0.15)
            )
            .foregroundColor(
                status == .pending ? theme.current.primary : .green
            )
            .clipShape(Capsule())
    }

    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Images")
                .font(.headline)
            if images.isEmpty {
                Text("No images uploaded")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(images.enumerated()), id: \.offset) {
                            _,
                            img in
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    )
                                )
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            PhotosPicker(selection: $pickedItems, matching: .images) {
                Label("Select Images", systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(theme.current.primary)
                    .foregroundColor(theme.current.textOnPrimary)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
            }
        }
    }

    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comments")
                .font(.headline)
            TextEditor(text: $comment)
                .frame(height: 120)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if task.status == .pending {
                Button(action: markComplete) {
                    Text("Mark as Complete")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(theme.current.primary)
                        .foregroundColor(theme.current.textOnPrimary)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )
                }
            } else {
                Text("Task completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func markComplete() {
        guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        withAnimation(.easeInOut(duration: 0.25)) {
            tasks[idx].status = .completed
        }
        isPresented = false
    }

    private func loadImages(from items: [PhotosPickerItem]) {
        images.removeAll()
        for item in items {
            Task { @MainActor in
                if let data = try? await item.loadTransferable(type: Data.self),
                    let ui = UIImage(data: data)
                {
                    images.append(Image(uiImage: ui))
                }
            }
        }
    }
}

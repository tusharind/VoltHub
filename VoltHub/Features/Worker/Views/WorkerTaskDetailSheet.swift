import PhotosUI
import SwiftUI

struct WorkerTaskDetailSheet: View {
    @Binding var task: WorkerTask
    let theme: Theme
    let onDismiss: () -> Void

    @State private var comments = ""
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var loadedImages: [UIImage] = []
    @State private var showingCompletionAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Task Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(task.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(
                                    Color(red: 0.3, green: 0.4, blue: 0.5)
                                )

                            Spacer()

                            StatusBadge(status: task.status, theme: theme)
                        }

                        if let meterID = task.meterID {
                            HStack {
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundColor(theme.primary)
                                Text("Meter ID: \(meterID)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                        if let location = task.location {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(theme.primary)
                                Text(location)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                        HStack {
                            Image(systemName: taskTypeIcon(for: task.type))
                                .foregroundColor(theme.primary)
                            Text(task.type.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.94, green: 0.95, blue: 0.96))
                    .cornerRadius(12)

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(
                                Color(red: 0.3, green: 0.4, blue: 0.5)
                            )

                        Text(task.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(red: 0.94, green: 0.95, blue: 0.96))
                    .cornerRadius(12)

                    // Image Upload Section (only for pending tasks)
                    if task.status == .pending {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Upload Images")
                                .font(.headline)
                                .foregroundColor(
                                    Color(red: 0.3, green: 0.4, blue: 0.5)
                                )

                            PhotosPicker(
                                selection: $selectedImages,
                                maxSelectionCount: 5,
                                matching: .images
                            ) {
                                HStack {
                                    Image(
                                        systemName: "photo.on.rectangle.angled"
                                    )
                                    .font(.title2)
                                    Text("Select Photos")
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(theme.textOnPrimary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(theme.primary)
                                .cornerRadius(10)
                            }

                            if !loadedImages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false)
                                {
                                    HStack(spacing: 12) {
                                        ForEach(
                                            loadedImages.indices,
                                            id: \.self
                                        ) { index in
                                            ZStack(alignment: .topTrailing) {
                                                Image(
                                                    uiImage: loadedImages[index]
                                                )
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(
                                                    RoundedRectangle(
                                                        cornerRadius: 8
                                                    )
                                                )

                                                Button {
                                                    loadedImages.remove(
                                                        at: index
                                                    )
                                                    selectedImages.remove(
                                                        at: index
                                                    )
                                                } label: {
                                                    Image(
                                                        systemName:
                                                            "xmark.circle.fill"
                                                    )
                                                    .foregroundColor(.white)
                                                    .background(
                                                        Color.black.opacity(0.6)
                                                    )
                                                    .clipShape(Circle())
                                                }
                                                .padding(4)
                                            }
                                        }
                                    }
                                }

                                Text("\(loadedImages.count) image(s) selected")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(red: 0.94, green: 0.95, blue: 0.96))
                        .cornerRadius(12)

                        // Comments Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Add Comments")
                                .font(.headline)
                                .foregroundColor(
                                    Color(red: 0.3, green: 0.4, blue: 0.5)
                                )

                            TextEditor(text: $comments)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(theme.background)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            Color.secondary.opacity(0.2),
                                            lineWidth: 1
                                        )
                                )

                            if comments.isEmpty {
                                Text("Optional: Add any notes or observations")
                                    .font(.caption)
                                    .foregroundColor(.secondary.opacity(0.7))
                            }
                        }
                        .padding()
                        .background(Color(red: 0.94, green: 0.95, blue: 0.96))
                        .cornerRadius(12)

                        // Mark Complete Button
                        Button {
                            showingCompletionAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                Text("Mark as Complete")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(theme.textOnPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(theme.primary)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        // Completed Status
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)

                            Text("Task Completed")
                                .font(.headline)
                                .foregroundColor(
                                    Color(red: 0.3, green: 0.4, blue: 0.5)
                                )

                            Text("This task has been marked as complete")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.94, green: 0.95, blue: 0.96))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .background(theme.background)
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .foregroundColor(theme.primary)
                }
            }
            .alert("Complete Task", isPresented: $showingCompletionAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm") {
                    markTaskAsComplete()
                }
            } message: {
                Text("Are you sure you want to mark this task as complete?")
            }
            .onChange(of: selectedImages) { _, newItems in
                loadImages(from: newItems)
            }
        }
    }

    private func taskTypeIcon(for type: TaskType) -> String {
        switch type {
        case .takeReading:
            return "gauge"
        case .installMeter:
            return "wrench.and.screwdriver"
        }
    }

    private func loadImages(from items: [PhotosPickerItem]) {
        loadedImages.removeAll()

        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            loadedImages.append(image)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }

    private func markTaskAsComplete() {
        task.status = .completed

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onDismiss()
        }
    }
}

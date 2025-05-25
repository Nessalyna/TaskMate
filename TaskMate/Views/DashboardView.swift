import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    let model = DashboardViewModel()
    @State private var showNewModal = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // User header
                    HStack(spacing: 16) {
                        Image(systemName: model.userAvatar)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.purple)
                            .background(Circle().fill(Color(.systemGray6)))
                            .accessibilityLabel("User Avatar")
                        VStack(alignment: .leading) {
                            Text("Hello, \(model.userName)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("habit Dashboard (") + Text("\(model.tasks.count)").bold() + Text(")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.top)
                    // Project cards
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(model.projects) { project in
                                Button(action: {
                                    print("[DEBUG] Project tapped: \(project.name)")
                                    // TODO: Navigate to Project Details
                                }) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(project.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        ProgressView(value: project.progress)
                                            .accentColor(project.color)
                                        HStack {
                                            Text("\(Int(project.progress * 100))% Complete")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text(project.dueDate, style: .date)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(project.color.opacity(0.2))
                                    .cornerRadius(16)
                                    .frame(width: 180)
                                }
                                .accessibilityLabel("Project: \(project.name)")
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    // All Tasks section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("All Tasks")
                            .font(.headline)
                        if model.tasks.isEmpty {
                            Text("No tasks assigned")
                                .foregroundColor(.secondary)
                                .padding(.vertical, 16)
                        } else {
                            ForEach(model.tasks.sorted { $0.dueDate < $1.dueDate }) { task in
                                Button(action: {
                                    print("[DEBUG] Task tapped: \(task.title)")
                                    // TODO: Navigate to Task Details
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(task.title)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            Text(task.project)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text(task.dueDate, style: .date)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        if task.isComplete {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .accessibilityLabel("Task: \(task.title)")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            // Floating action button
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            print("[DEBUG] Floating + tapped")
                            showNewModal = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.purple)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .accessibilityLabel("Add new task or project")
                        .padding()
                    }
                }
            )
            // Modal for new task/project
            .sheet(isPresented: $showNewModal) {
                // TODO: Implement NewTaskOrProjectView
                VStack(spacing: 24) {
                    Text("Create New")
                        .font(.title2)
                        .fontWeight(.bold)
                    Button("New Task") {
                        print("[DEBUG] New Task selected")
                        showNewModal = false
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    Button("New Project") {
                        print("[DEBUG] New Project selected")
                        showNewModal = false
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    Button("Cancel") {
                        showNewModal = false
                    }
                    .foregroundColor(.red)
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
} 
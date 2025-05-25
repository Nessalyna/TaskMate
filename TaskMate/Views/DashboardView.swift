import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @ObservedObject var model: DashboardViewModel
    var onAddProject: () -> Void
    var onAddTask: () -> Void
    var onProjectTapped: (DashboardViewModel.Project) -> Void
    var onTaskTapped: (DashboardViewModel.Task) -> Void
    var onProfileTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                ProjectSectionView(projects: model.projects, onAddProject: onAddProject, onProjectTapped: onProjectTapped)
                TaskSectionView(tasks: model.tasks, onAddTask: onAddTask, onTaskTapped: onTaskTapped)
            }
        }
    }
    
    // MARK: - Subviews
    private var headerView: some View {
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
                Text("habit Dashboard (\(model.tasks.count))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                print("[DEBUG] Profile/settings tapped")
                onProfileTapped()
            }) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.purple)
            }
            .accessibilityLabel("Profile/Settings")
        }
        .padding([.top, .horizontal])
    }
}

private struct ProjectSectionView: View {
    let projects: [DashboardViewModel.Project]
    var onAddProject: () -> Void
    var onProjectTapped: (DashboardViewModel.Project) -> Void
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Projects")
                    .font(.headline)
                Spacer()
                Button(action: onAddProject) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Project")
                    }
                    .foregroundColor(.purple)
                }
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(projects) { project in
                        Button(action: { onProjectTapped(project) }) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(project.name)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
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
                .padding(.horizontal)
            }
        }
    }
}

private struct TaskSectionView: View {
    let tasks: [DashboardViewModel.Task]
    var onAddTask: () -> Void
    var onTaskTapped: (DashboardViewModel.Task) -> Void
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("All Tasks")
                    .font(.headline)
                Spacer()
                Button(action: onAddTask) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Task")
                    }
                    .foregroundColor(.purple)
                }
            }
            .padding(.horizontal)
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if tasks.isEmpty {
                        Text("No tasks assigned")
                            .foregroundColor(.secondary)
                            .padding(.vertical, 16)
                    } else {
                        ForEach(tasks.sorted { $0.dueDate < $1.dueDate }) { task in
                            Button(action: { onTaskTapped(task) }) {
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
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .accessibilityLabel("Task: \(task.title)")
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Preview
// #Preview {
//     DashboardView(...)
// } 

import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    @ObservedObject var model: DashboardViewModel
    var onAddProject: () -> Void
    var onAddTask: () -> Void
    var onProjectTapped: (Project) -> Void
    var onTaskTapped: (Task) -> Void
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
    let projects: [Project]
    var onAddProject: () -> Void
    var onProjectTapped: (Project) -> Void
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
                    let projectList: [Project] = projects
                    ForEach(projectList, id: \ .id) { project in
                        ProjectCardView(project: project, onTap: { onProjectTapped(project) })
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
        }
    }
}

private struct ProjectCardView: View {
    let project: Project
    let onTap: () -> Void
    var body: some View {
        // Break up complex expressions for compiler
        let totalTasks = project.tasks.count
        let completedTasks = project.tasks.filter { $0.isComplete }.count
        let progress: Double = totalTasks == 0 ? 0 : Double(completedTasks) / Double(totalTasks)
        let percentComplete: Int = totalTasks == 0 ? 0 : Int(progress * 100)

        return Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(project.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                ProgressView(value: progress)
                    .accentColor(Color(hex: project.colorHex))
                HStack {
                    Text("\(percentComplete)% Complete")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(project.endDate, style: .date)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(hex: project.colorHex).opacity(0.2))
            .cornerRadius(16)
            .frame(width: 180)
        }
        .accessibilityLabel("Project: \(project.name)")
    }
}

private struct TaskSectionView: View {
    let tasks: [Task]
    var onAddTask: () -> Void
    var onTaskTapped: (Task) -> Void
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
                        let sortedTasks: [Task] = tasks.sorted { $0.dueDate < $1.dueDate }
                        ForEach(sortedTasks, id: \ .id) { task in
                            TaskRowView(task: task, onTap: { onTaskTapped(task) })
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct TaskRowView: View {
    let task: Task
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(task.projectId)
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

// MARK: - Color Helper
extension Color {
    // Helper to create Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
// #Preview {
//     DashboardView(...)
// } 

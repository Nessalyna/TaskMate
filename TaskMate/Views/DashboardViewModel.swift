import SwiftUI
import SwiftData

@Observable
final class DashboardViewModel: ObservableObject {
    // MARK: - Properties
    // User info (placeholder, should be replaced with actual User model usage)
    var userName: String = "Vanessa"
    var userAvatar: String = "person.crop.circle.fill"

    // Use global Project and Task models
    var projects: [Project] = []
    var tasks: [Task] = []

    // MARK: - Methods
    // Add debug logs for actions
    func addTask(_ task: Task) {
        print("[DEBUG] Adding new task: \(task.title)")
        tasks.append(task)
    }
    func addProject(_ project: Project) {
        print("[DEBUG] Adding new project: \(project.name)")
        projects.append(project)
    }
} 

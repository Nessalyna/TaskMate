import SwiftUI

@Observable
final class DashboardViewModel: ObservableObject {
    // MARK: - Properties
    // User info
    var userName: String = "Vanessa"
    var userAvatar: String = "person.crop.circle.fill"
    
    // Project model
    struct Project: Identifiable, Hashable {
        let id: UUID
        let name: String
        let color: Color
        let progress: Double // 0.0 - 1.0
        let dueDate: Date
        let tasks: [Task]
    }
    
    // Task model
    struct Task: Identifiable, Hashable {
        let id: UUID
        let title: String
        let project: String
        let dueDate: Date
        let isComplete: Bool
    }
    
    // Sample data for UI (not for dev/prod)
    var projects: [Project] = [
        Project(id: UUID(), name: "School Project", color: .yellow, progress: 0.7, dueDate: Date().addingTimeInterval(86400 * 3), tasks: []),
        Project(id: UUID(), name: "Personal", color: .purple, progress: 0.3, dueDate: Date().addingTimeInterval(86400 * 7), tasks: [])
    ]
    var tasks: [Task] = [
        Task(id: UUID(), title: "Psychology 401 project work", project: "School Project", dueDate: Date().addingTimeInterval(86400 * 2), isComplete: false),
        Task(id: UUID(), title: "Handle house chores", project: "Personal", dueDate: Date().addingTimeInterval(86400 * 5), isComplete: false)
    ]
    
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

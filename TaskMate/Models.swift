import Foundation
import SwiftData

// MARK: - User Model
@Model
final class User {
    @Attribute(.unique) var id: String // Firebase UID
    var name: String
    var email: String
    var avatarURL: String?
    var phone: String?
    var createdAt: Date
    
    init(id: String, name: String, email: String, avatarURL: String? = nil, phone: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.phone = phone
        self.createdAt = createdAt
        print("[DEBUG] User model initialized: \(name)")
    }
}

// MARK: - Project Model
@Model
final class Project {
    @Attribute(.unique) var id: String // Firebase doc ID
    var name: String
    var details: String // Renamed from 'description' to 'details' to avoid linter error
    var colorHex: String
    var startDate: Date
    var endDate: Date
    var members: [String] // User IDs
    var tasks: [Task]
    var createdAt: Date
    
    init(id: String, name: String, details: String, colorHex: String, startDate: Date, endDate: Date, members: [String], tasks: [Task] = [], createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.details = details
        self.colorHex = colorHex
        self.startDate = startDate
        self.endDate = endDate
        self.members = members
        self.tasks = tasks
        self.createdAt = createdAt
        print("[DEBUG] Project model initialized: \(name)")
    }
}

// MARK: - Task Model
@Model
final class Task {
    @Attribute(.unique) var id: String // Firebase doc ID
    var title: String
    var details: String // Renamed from 'description' to 'details' to avoid linter error
    var projectId: String
    var assigneeId: String?
    var startDate: Date
    var dueDate: Date
    var priority: String
    var isComplete: Bool
    var subtasks: [Subtask]
    var comments: [Comment]
    var attachments: [String] // URLs
    var createdAt: Date
    
    init(id: String, title: String, details: String, projectId: String, assigneeId: String? = nil, startDate: Date, dueDate: Date, priority: String = "Normal", isComplete: Bool = false, subtasks: [Subtask] = [], comments: [Comment] = [], attachments: [String] = [], createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.details = details
        self.projectId = projectId
        self.assigneeId = assigneeId
        self.startDate = startDate
        self.dueDate = dueDate
        self.priority = priority
        self.isComplete = isComplete
        self.subtasks = subtasks
        self.comments = comments
        self.attachments = attachments
        self.createdAt = createdAt
        print("[DEBUG] Task model initialized: \(title)")
    }
}

// MARK: - Subtask Model
@Model
final class Subtask {
    @Attribute(.unique) var id: String // Firebase doc ID
    var title: String
    var details: String // Renamed from 'description' to 'details' to avoid linter error
    var isComplete: Bool
    var createdAt: Date
    
    init(id: String, title: String, details: String, isComplete: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.details = details
        self.isComplete = isComplete
        self.createdAt = createdAt
        print("[DEBUG] Subtask model initialized: \(title)")
    }
}

// MARK: - Comment Model
@Model
final class Comment {
    @Attribute(.unique) var id: String // Firebase doc ID
    var userId: String
    var text: String
    var timestamp: Date
    
    init(id: String, userId: String, text: String, timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.text = text
        self.timestamp = timestamp
        print("[DEBUG] Comment model initialized: \(text.prefix(20))")
    }
}

// MARK: - Notification Model
@Model
final class AppNotification {
    @Attribute(.unique) var id: String // Firebase doc ID
    var userId: String
    var title: String
    var message: String
    var date: Date
    var isRead: Bool
    var type: String // e.g. "Task", "Project", "Comment"
    var relatedId: String? // Task or Project ID
    
    init(id: String, userId: String, title: String, message: String, date: Date = Date(), isRead: Bool = false, type: String, relatedId: String? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.message = message
        self.date = date
        self.isRead = isRead
        self.type = type
        self.relatedId = relatedId
        print("[DEBUG] Notification model initialized: \(title)")
    }
} 
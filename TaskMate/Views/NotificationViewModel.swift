import SwiftUI

class NotificationViewModel: ObservableObject {
    // MARK: - Notification Model
    struct Notification: Identifiable, Equatable {
        let id: UUID
        let title: String
        let message: String
        let date: Date
        let isRead: Bool
        let type: String // e.g. "Task", "Project", "Comment"
        let relatedId: UUID? // Task or Project ID
    }
    // MARK: - Properties
    @Published var notifications: [Notification] = [
        Notification(id: UUID(), title: "Task Assigned", message: "You have been assigned 'Psychology 401 project work'", date: Date().addingTimeInterval(-3600), isRead: false, type: "Task", relatedId: nil),
        Notification(id: UUID(), title: "Project Updated", message: "School Project deadline changed", date: Date().addingTimeInterval(-7200), isRead: true, type: "Project", relatedId: nil),
        Notification(id: UUID(), title: "Comment Mention", message: "@Vanessa mentioned you in 'Personal'", date: Date().addingTimeInterval(-10800), isRead: false, type: "Comment", relatedId: nil)
    ]
    // MARK: - Methods
    func markAsRead(_ notification: Notification) {
        if let idx = notifications.firstIndex(of: notification) {
            notifications[idx] = Notification(
                id: notification.id,
                title: notification.title,
                message: notification.message,
                date: notification.date,
                isRead: true,
                type: notification.type,
                relatedId: notification.relatedId
            )
            print("[DEBUG] Notification marked as read: \(notification.title)")
        }
    }
    func delete(_ notification: Notification) {
        notifications.removeAll { $0.id == notification.id }
        print("[DEBUG] Notification deleted: \(notification.title)")
    }
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
} 
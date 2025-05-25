import SwiftUI

struct NotificationsView: View {
    // MARK: - Properties
    @StateObject private var model = NotificationViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if model.notifications.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal")
                            .font(.system(size: 48))
                            .foregroundColor(.purple)
                        Text("You're all caught up!")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("No notifications at the moment.")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    List {
                        Section(header: Text("Unread")) {
                            ForEach(model.notifications.filter { !$0.isRead }) { notification in
                                NotificationRow(notification: notification, isUnread: true) {
                                    model.markAsRead(notification)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        model.delete(notification)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        Section(header: Text("Read")) {
                            ForEach(model.notifications.filter { $0.isRead }) { notification in
                                NotificationRow(notification: notification, isUnread: false) {}
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            model.delete(notification)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Notifications")
        }
    }
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: NotificationViewModel.Notification
    let isUnread: Bool
    let onTap: () -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(isUnread ? Color.purple : Color.gray.opacity(0.3))
                .frame(width: 12, height: 12)
                .padding(.top, 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .fontWeight(isUnread ? .bold : .regular)
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(notification.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("[DEBUG] Notification tapped: \(notification.title)")
            onTap()
        }
        .accessibilityLabel("Notification: \(notification.title)")
        .background(isUnread ? Color.purple.opacity(0.07) : Color.clear)
        .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    NotificationsView()
} 
import SwiftUI

struct TaskDetailView: View {
    // MARK: - Properties
    let task: Task // Use global Task
    @State private var comments: [Comment] = [] // Use global Comment
    @State private var newComment: String = ""
    @State private var showMentionSuggestions = false
    @State private var mentionQuery = ""
    // Placeholder users for mention
    let users = ["Nessa", "Ben", "Nana", "Vanessa"]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Task Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(task.projectId) // Show projectId or resolve to project name if needed
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(task.dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Divider()
                    // Comments Section
                    Text("Comments")
                        .font(.headline)
                    ForEach(comments.sorted { $0.timestamp < $1.timestamp }, id: \ .id) { comment in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(Color.purple.opacity(0.7))
                                .frame(width: 32, height: 32)
                                .overlay(Text(String(comment.userId.prefix(1))).foregroundColor(.white))
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(comment.userId)
                                        .fontWeight(.semibold)
                                    Text(comment.timestamp, style: .time)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Text(comment.text)
                                    .font(.body)
                                    .foregroundColor(comment.text.contains("@") ? .purple : .primary)
                            }
                            Spacer()
                        }
                    }
                    if comments.isEmpty {
                        Text("No comments yet. Start the conversation!")
                            .foregroundColor(.secondary)
                            .padding(.vertical, 16)
                    }
                }
                .padding()
            }
            // New Comment Input
            Divider()
            HStack(spacing: 8) {
                TextField("Add a comment...", text: $newComment, onEditingChanged: { editing in
                    if editing, let atIdx = newComment.lastIndex(of: "@") {
                        mentionQuery = String(newComment[atIdx...]).trimmingCharacters(in: ["@"])
                        showMentionSuggestions = !mentionQuery.isEmpty
                    } else {
                        showMentionSuggestions = false
                    }
                })
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Add a comment")
                Button(action: {
                    guard !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    print("[DEBUG] New comment added: \(newComment)")
                    comments.append(Comment(id: UUID().uuidString, userId: "Nessa", text: newComment, timestamp: Date()))
                    newComment = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.purple)
                        .font(.title2)
                }
                .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            // Mention Suggestions (placeholder)
            if showMentionSuggestions {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(users.filter { $0.lowercased().contains(mentionQuery.lowercased()) }, id: \ .self) { user in
                            Button("@\(user)") {
                                newComment += user.dropFirst(mentionQuery.count)
                                showMentionSuggestions = false
                            }
                            .padding(6)
                            .background(Color.purple.opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Task Details")
    }
}

// MARK: - Preview
#Preview {
    TaskDetailView(task: DashboardViewModel().tasks[0])
} 
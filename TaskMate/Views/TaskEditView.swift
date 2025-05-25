import SwiftUI

struct TaskEditView: View {
    // MARK: - Properties
    @State var title: String = ""
    @State var type: String = "Personal"
    @State var description: String = ""
    @State var startDate: Date = Date()
    @State var dueDate: Date = Date().addingTimeInterval(86400 * 3)
    @State var priority: String = "Normal"
    @State var assignee: String = "" // Placeholder
    @State var attachments: [String] = [] // Placeholder
    @State var showValidationError = false
    var onSave: ((String, String, String, Date, Date, String, String, [String]) -> Void)?
    var isEditing: Bool = false
    var onCancel: (() -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Task Title", text: $title)
                    .accessibilityLabel("Task Title")
                if showValidationError && title.isEmpty {
                    Text("Task title is required.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Picker("Task Type", selection: $type) {
                    Text("Personal").tag("Personal")
                    Text("School Project").tag("School Project")
                    Text("Work").tag("Work")
                }
                .accessibilityLabel("Task Type")
                TextField("Description", text: $description)
                    .accessibilityLabel("Description")
            }
            Section(header: Text("Dates")) {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            Section(header: Text("Priority & Assignee")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Normal").tag("Normal")
                    Text("High").tag("High")
                }
                .accessibilityLabel("Priority")
                TextField("Assignee (coming soon)", text: $assignee)
                    .disabled(true)
                    .accessibilityLabel("Assignee")
            }
            Section(header: Text("Attachments")) {
                // Placeholder for attachments
                Text("Attachment upload coming soon")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(isEditing ? "Edit Task" : "New Task")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    print("[DEBUG] Task creation/edit cancelled")
                    onCancel?()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if title.isEmpty {
                        showValidationError = true
                        print("[DEBUG] Validation failed: Task title is empty")
                    } else {
                        print("[DEBUG] Task saved: \(title)")
                        onSave?(title, type, description, startDate, dueDate, priority, assignee, attachments)
                    }
                }
                .disabled(title.isEmpty)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TaskEditView()
} 
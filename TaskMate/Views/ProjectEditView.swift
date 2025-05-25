import SwiftUI

struct ProjectEditView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State var name: String = ""
    @State var description: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date().addingTimeInterval(86400 * 7)
    @State var members: [String] = [] // Placeholder for member selection
    @State var showValidationError = false
    var onSave: ((String, String, Date, Date, [String]) -> Void)?
    var isEditing: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Project Info")) {
                    TextField("Project Name", text: $name)
                        .accessibilityLabel("Project Name")
                    if showValidationError && name.isEmpty {
                        Text("Project name is required.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    TextField("Description", text: $description)
                        .accessibilityLabel("Description")
                }
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                Section(header: Text("Members")) {
                    // Placeholder for member selection
                    Text("Member selection coming soon")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(isEditing ? "Edit Project" : "New Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        print("[DEBUG] Project creation/edit cancelled")
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if name.isEmpty {
                            showValidationError = true
                            print("[DEBUG] Validation failed: Project name is empty")
                        } else {
                            print("[DEBUG] Project saved: \(name)")
                            onSave?(name, description, startDate, endDate, members)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProjectEditView()
} 
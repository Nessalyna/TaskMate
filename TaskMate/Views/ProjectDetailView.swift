import SwiftUI

struct ProjectDetailView: View {
    // MARK: - Properties
    let project: DashboardViewModel.Project
    @State private var showEditModal = false
    @State private var showAddTaskModal = false
    @State private var showKanban = false
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Project header
                HStack(alignment: .center, spacing: 16) {
                    Circle()
                        .fill(project.color)
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(project.dueDate, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: {
                        print("[DEBUG] Edit Project tapped")
                        showEditModal = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    .accessibilityLabel("Edit Project")
                }
                // Progress bar
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: project.progress)
                        .accentColor(project.color)
                    Text("\(Int(project.progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                // Description
                if !project.name.isEmpty {
                    Text(project.name)
                        .font(.headline)
                }
                // Members (placeholder chips)
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(Color.purple.opacity(0.7 - Double(i) * 0.2))
                            .frame(width: 32, height: 32)
                            .overlay(Text("B").foregroundColor(.white))
                    }
                    Text("+2 more")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                // List/Kanban toggle
                HStack {
                    Button(action: { showKanban = false }) {
                        Text("List")
                            .fontWeight(showKanban ? .regular : .bold)
                            .foregroundColor(showKanban ? .gray : .purple)
                    }
                    Button(action: { showKanban = true }) {
                        Text("Kanban")
                            .fontWeight(showKanban ? .bold : .regular)
                            .foregroundColor(showKanban ? .purple : .gray)
                    }
                    Spacer()
                    Button(action: {
                        print("[DEBUG] Add Task tapped")
                        showAddTaskModal = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Task")
                        }
                        .foregroundColor(.purple)
                        .font(.headline)
                    }
                }
                // Tasks (placeholder)
                if showKanban {
                    Text("[Kanban view coming soon]")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 120)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(project.tasks) { task in
                            HStack {
                                Text(task.title)
                                Spacer()
                                if task.isComplete {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        if project.tasks.isEmpty {
                            Text("No tasks in this project.")
                                .foregroundColor(.secondary)
                                .padding(.vertical, 16)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Project Details")
        .sheet(isPresented: $showEditModal) {
            // TODO: ProjectEditView
            Text("Edit Project Modal")
                .font(.title)
                .padding()
        }
        .sheet(isPresented: $showAddTaskModal) {
            // TODO: AddTaskView
            Text("Add Task Modal")
                .font(.title)
                .padding()
        }
    }
}

// MARK: - Preview
#Preview {
    ProjectDetailView(project: DashboardViewModel().projects[0])
} 
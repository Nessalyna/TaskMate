import SwiftUI

struct ProjectDetailView: View {
    // MARK: - Properties
    let project: Project // Use global Project
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
                        .fill(Color(hex: project.colorHex))
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(project.endDate, style: .date)
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
                    let progress = project.tasks.isEmpty ? 0 : Double(project.tasks.filter { $0.isComplete }.count) / Double(project.tasks.count)
                    ProgressView(value: progress)
                        .accentColor(Color(hex: project.colorHex))
                    Text("\(Int(progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                // Details
                if !project.details.isEmpty {
                    Text(project.details)
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
                        ForEach(project.tasks, id: \ .id) { task in
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

// MARK: - Color Helper
//extension Color {
//    // Helper to create Color from hex string
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (255, 0, 0, 0)
//        }
//     
//      
//    }
//}

// MARK: - Preview
#Preview {
    ProjectDetailView(project: DashboardViewModel().projects[0])
} 

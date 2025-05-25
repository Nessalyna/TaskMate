//
//  ContentView.swift
//  TaskMate
//
//  Created by OFTP on 23/05/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    @State private var showProfile = false
    @State private var navigationPath = NavigationPath()
    @StateObject private var model = DashboardViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case 0:
                        DashboardView(
                            model: model,
                            onAddProject: { navigationPath.append("newProject") },
                            onAddTask: { navigationPath.append("newTask") },
                            onProjectTapped: { navigationPath.append($0) },
                            onTaskTapped: { navigationPath.append($0) },
                            onProfileTapped: { showProfile = true }
                        )
                    case 1:
                        DashboardView(
                            model: model,
                            onAddProject: { navigationPath.append("newProject") },
                            onAddTask: { navigationPath.append("newTask") },
                            onProjectTapped: { navigationPath.append($0) },
                            onTaskTapped: { navigationPath.append($0) },
                            onProfileTapped: { showProfile = true }
                        )
                    case 2:
                        NotificationsView()
                    default:
                        DashboardView(
                            model: model,
                            onAddProject: { navigationPath.append("newProject") },
                            onAddTask: { navigationPath.append("newTask") },
                            onProjectTapped: { navigationPath.append($0) },
                            onTaskTapped: { navigationPath.append($0) },
                            onProfileTapped: { showProfile = true }
                        )
                    }
                }
                // Custom Tab Bar
                HStack {
                    Spacer()
                    Button(action: { selectedTab = 0 }) {
                        VStack {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                                .font(.system(size: 24, weight: .bold))
                            Text("Dashboard").font(.caption)
                        }
                        .foregroundColor(selectedTab == 0 ? .purple : .gray)
                    }
                    Spacer()
                    Button(action: { navigationPath.append("newTask") }) {
                        ZStack {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 64, height: 64)
                                .shadow(radius: 6)
                            Image(systemName: "plus")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(y: -24)
                    }
                    .accessibilityLabel("Add new task")
                    Spacer()
                    Button(action: { selectedTab = 2 }) {
                        VStack {
                            Image(systemName: selectedTab == 2 ? "bell.fill" : "bell")
                                .font(.system(size: 24, weight: .bold))
                            Text("Notifications").font(.caption)
                        }
                        .foregroundColor(selectedTab == 2 ? .purple : .gray)
                    }
                    Spacer()
                }
                .frame(height: 72)
                .background(
                    Color(.systemBackground)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, y: -2)
                )
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationDestination(for: String.self) { route in
                if route == "newTask" {
                    TaskEditView(onSave: { title, type, description, start, due, priority, assignee, attachments in
                        let newTask = Task(
                            id: UUID().uuidString,
                            title: title,
                            details: description,
                            projectId: type, // Should resolve to projectId if needed
                            assigneeId: assignee,
                            startDate: start,
                            dueDate: due,
                            priority: priority,
                            isComplete: false,
                            subtasks: [],
                            comments: [],
                            attachments: attachments,
                            createdAt: Date()
                        )
                        model.addTask(newTask)
                        navigationPath = NavigationPath()
                    }, onCancel: { navigationPath = NavigationPath() })
                } else if route == "newProject" {
                    ProjectEditView(onSave: { name, description, start, end, members in
                        let newProject = Project(
                            id: UUID().uuidString,
                            name: name,
                            details: description,
                            colorHex: "FFD600", // Default yellow
                            startDate: start,
                            endDate: end,
                            members: members,
                            tasks: [],
                            createdAt: Date()
                        )
                        model.addProject(newProject)
                        navigationPath = NavigationPath()
                    }, onCancel: { navigationPath = NavigationPath() })
                } else {
                    EmptyView()
                }
            }
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .navigationDestination(for: Task.self) { task in
                TaskDetailView(task: task)
            }
            .sheet(isPresented: $showProfile) {
                SettingsView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

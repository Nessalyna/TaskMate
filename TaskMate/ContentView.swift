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
    @State private var showAddModal = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case 0:
                    DashboardView()
                case 1:
                    // Center tab is Add, so show Dashboard by default
                    DashboardView()
                case 2:
                    NotificationsView()
                default:
                    DashboardView()
                }
            }
            // Custom Tab Bar
            HStack {
                Spacer()
                // Dashboard Tab
                Button(action: {
                    print("[DEBUG] Dashboard tab tapped")
                    selectedTab = 0
                }) {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .font(.system(size: 24, weight: .bold))
                        Text("Dashboard")
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == 0 ? .purple : .gray)
                }
                Spacer()
                // Add Tab (center, floating)
                Button(action: {
                    print("[DEBUG] Add tab tapped")
                    showAddModal = true
                }) {
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
                .accessibilityLabel("Add new task or project")
                Spacer()
                // Notifications Tab
                Button(action: {
                    print("[DEBUG] Notifications tab tapped")
                    selectedTab = 2
                }) {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "bell.fill" : "bell")
                            .font(.system(size: 24, weight: .bold))
                        Text("Notifications")
                            .font(.caption)
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
            // Add Modal
            .sheet(isPresented: $showAddModal) {
                VStack(spacing: 24) {
                    Text("Create New")
                        .font(.title2)
                        .fontWeight(.bold)
                    Button("New Task") {
                        print("[DEBUG] New Task selected from Add tab")
                        showAddModal = false
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    Button("New Project") {
                        print("[DEBUG] New Project selected from Add tab")
                        showAddModal = false
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    Button("Cancel") {
                        showAddModal = false
                    }
                    .foregroundColor(.red)
                }
                .padding()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

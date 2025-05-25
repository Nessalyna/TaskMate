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
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            NotificationsView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(.blue) // Use the app's accent color
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

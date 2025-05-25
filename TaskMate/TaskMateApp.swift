//
//  TaskMateApp.swift
//  TaskMate
//
//  Created by OFTP on 23/05/2025.
//

import SwiftUI

@main
struct TaskMateApp: App {
    // MARK: - Properties
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("isAuthenticated") private var isAuthenticated = false
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if !isAuthenticated {
                SignUpView(onAuthenticated: {
                    isAuthenticated = true
                })
            } else {
                ContentView()
                    .environment(\.colorScheme, .light) // Default to light mode
            }
        }
    }
}

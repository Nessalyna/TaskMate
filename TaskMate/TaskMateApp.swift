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
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environment(\.colorScheme, .light) // Default to light mode
            } else {
                OnboardingView()
            }
        }
    }
}

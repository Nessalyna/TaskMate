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
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .light) // Default to light mode
        }
    }
}

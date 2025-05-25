//
//  TaskMateApp.swift
//  TaskMate
//
//  Created by OFTP on 23/05/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct TaskMateApp: App {
    // MARK: - Properties
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    // Use a shared AuthViewModel for the app
    @State private var authModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            // Call checkSession() on launch
            RootView(authModel: authModel, hasSeenOnboarding: $hasSeenOnboarding)
                .environment(\.colorScheme, .light) // Default to light mode
                .onAppear {
                    print("[DEBUG] App launched, checking session...")
                    authModel.checkSession()
                }
        }
    }
}

// RootView handles onboarding, auth, and main content
struct RootView: View {
    @Bindable var authModel: AuthViewModel
    @Binding var hasSeenOnboarding: Bool
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView()
        } else if !authModel.isAuthenticated {
            SignUpView(authModel: authModel, onAuthenticated: {
                authModel.checkSession()
            })
        } else {
            ContentView()
        }
    }
}

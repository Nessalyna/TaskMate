import SwiftUI

struct OnboardingView: View {
    // MARK: - Properties
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSignUp = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                // App logo or illustration
                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.purple)
                    .accessibilityLabel("App Logo")
                
                // Welcome text
                Text("Welcome to TaskMate!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("Organize your projects, track your tasks, and collaborate effortlessly.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                // Get Started button
                Button(action: {
                    print("[DEBUG] Onboarding completed, moving to Sign Up.")
                    hasSeenOnboarding = true
                    showSignUp = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .accessibilityLabel("Get Started")
                Spacer(minLength: 32)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
} 
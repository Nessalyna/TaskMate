import SwiftUI

struct SignInView: View {
    // MARK: - Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showDashboard = false
    @State private var showSignUp = false
    @State private var isLoading = false
    @State var authModel: AuthViewModel

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                // Title
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 32)
                // Email input
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .accessibilityLabel("Email")
                // Password input
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Password")
                // Error message
                if let error = authModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                // Sign In button
                Button(action: {
                    print("[DEBUG] Sign In tapped. Email: \(email)")
                    isLoading = true
                    authModel.signIn(email: email, password: password) { success in
                        isLoading = false
                        if success {
                            showDashboard = true
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.top)
                .accessibilityLabel("Sign In")
                // Link to Sign Up
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    Button("Sign Up") {
                        print("[DEBUG] Navigate to Sign Up")
                        showSignUp = true
                    }
                    .foregroundColor(.purple)
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationDestination(isPresented: $showDashboard) {
                ContentView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView(authModel: authModel)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignInView(authModel: AuthViewModel())
} 
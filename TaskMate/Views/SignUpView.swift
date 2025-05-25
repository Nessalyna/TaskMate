import SwiftUI

struct SignUpView: View {
    // MARK: - Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var nickname: String = ""
    @State private var showVerification = false
    @State private var showSignIn = false
    @State private var isLoading = false
    @State var authModel: AuthViewModel = AuthViewModel()
    var onAuthenticated: (() -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                // Title
                Text("Sign Up")
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
                // Nickname input
                TextField("Nickname", text: $nickname)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Nickname")
                // Error message
                if let error = authModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                // Sign Up button
                Button(action: {
                    print("[DEBUG] Sign Up tapped. Email: \(email), Nickname: \(nickname)")
                    guard !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        authModel.errorMessage = "Nickname is required."
                        return
                    }
                    isLoading = true
                    authModel.signUp(email: email, password: password, nickname: nickname) { success in
                        isLoading = false
                        if success {
                            showVerification = true
                            onAuthenticated?()
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign Up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.top)
                .accessibilityLabel("Sign Up")
                // Link to Sign In
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.secondary)
                    Button("Sign In") {
                        print("[DEBUG] Navigate to Sign In")
                        showSignIn = true
                    }
                    .foregroundColor(.purple)
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationDestination(isPresented: $showVerification) {
                VerificationView(onAuthenticated: onAuthenticated)
            }
            .navigationDestination(isPresented: $showSignIn) {
                SignInView(authModel: authModel)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
} 

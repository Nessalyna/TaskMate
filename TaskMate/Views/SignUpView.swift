import SwiftUI

struct SignUpView: View {
    // MARK: - Properties
    @State private var phoneNumber: String = ""
    @State private var countryCode: String = "+233"
    @State private var nickname: String = ""
    @State private var showVerification = false
    @State private var showSignIn = false
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
                // Phone input
                HStack {
                    TextField("+233", text: $countryCode)
                        .frame(width: 60)
                        .keyboardType(.phonePad)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Country Code")
                    TextField("Enter your mobile number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel("Mobile Number")
                }
                // Nickname input
                TextField("Nickname", text: $nickname)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Nickname")
                // Sign Up button
                Button(action: {
                    print("[DEBUG] Sign Up tapped. Phone: \(countryCode)\(phoneNumber), Nickname: \(nickname)")
                    showVerification = true
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
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
                SignInView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
} 
import SwiftUI

struct SignInView: View {
    // MARK: - Properties
    @State private var phoneNumber: String = ""
    @State private var countryCode: String = "+233"
    @State private var showDashboard = false
    @State private var showSignUp = false
    
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
                // Sign In button
                Button(action: {
                    print("[DEBUG] Sign In tapped. Phone: \(countryCode)\(phoneNumber)")
                    showDashboard = true
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
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
                SignUpView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignInView()
} 
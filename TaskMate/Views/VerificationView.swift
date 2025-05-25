import SwiftUI

struct VerificationView: View {
    // MARK: - Properties
    @State private var code: [String] = Array(repeating: "", count: 5)
    @FocusState private var focusedIndex: Int?
    @State private var showDashboard = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Verify your account")
                .font(.title)
                .fontWeight(.bold)
            Text("Kindly enter your email and enter the 5-digit code")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            // Code input
            HStack(spacing: 12) {
                ForEach(0..<5, id: \ .self) { i in
                    TextField("", text: $code[i])
                        .frame(width: 44, height: 44)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($focusedIndex, equals: i)
                        .onChange(of: code[i]) { _ in
                            if code[i].count == 1 && i < 4 {
                                focusedIndex = i + 1
                            }
                        }
                        .accessibilityLabel("Digit \(i+1)")
                }
            }
            // Continue button
            Button(action: {
                print("[DEBUG] Verification code entered: \(code.joined())")
                showDashboard = true
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .accessibilityLabel("Continue")
            // Resend code
            Button("Resend Code") {
                print("[DEBUG] Resend code tapped")
            }
            .foregroundColor(.purple)
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationDestination(isPresented: $showDashboard) {
            ContentView()
        }
    }
}

// MARK: - Preview
#Preview {
    VerificationView()
} 
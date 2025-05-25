import SwiftUI
import FirebaseFirestore

struct SettingsView: View {
    // MARK: - Properties
    var authModel: AuthViewModel
    @State private var nickname: String = ""
    @State private var mobile: String = "+233245678910"
    @State private var showEdit = false
    @State private var showFeedback = false
    @State private var feedbackText = ""
    @State private var notificationsEnabled = true
    @State private var showLogoutAlert = false
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var showImagePicker = false
    @State private var isSaving = false
    @State private var errorMessage: String? = nil
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                // Profile Section
                Section {
                    HStack(spacing: 16) {
                        profileImage?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .onTapGesture {
                                print("[DEBUG] Profile image tapped")
                                showImagePicker = true
                            }
                            .accessibilityLabel("Profile Picture")
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authModel.userProfile?.nickname ?? "")
                                .font(.headline)
                            Text(authModel.userProfile?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            print("[DEBUG] Edit profile tapped")
                            nickname = authModel.userProfile?.nickname ?? ""
                            showEdit = true
                        }) {
                            Image(systemName: "pencil")
                        }
                        .accessibilityLabel("Edit Profile")
                    }
                }
                // Notification Toggle
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    .onChange(of: notificationsEnabled) { value in
                        print("[DEBUG] Notifications toggled: \(value)")
                    }
                }
                // Feedback
                Section(header: Text("Feedback")) {
                    Button("Send Feedback") {
                        print("[DEBUG] Feedback tapped")
                        showFeedback = true
                    }
                }
                // Logout
                Section {
                    Button(role: .destructive) {
                        print("[DEBUG] Logout tapped")
                        showLogoutAlert = true
                    } label: {
                        Text("Log out")
                    }
                }
            }
            .navigationTitle("Profile")
            // Edit Profile Modal
            .sheet(isPresented: $showEdit) {
                NavigationStack {
                    Form {
                        TextField("Nickname", text: $nickname)
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Button("Save") {
                            isSaving = true
                            updateNickname()
                        }
                        .disabled(nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        if isSaving {
                            ProgressView()
                        }
                    }
                    .navigationTitle("Edit Profile")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showEdit = false
                            }
                        }
                    }
                }
            }
            // Feedback Modal
            .sheet(isPresented: $showFeedback) {
                NavigationStack {
                    Form {
                        TextField("Your feedback...", text: $feedbackText, axis: .vertical)
                            .lineLimit(4...8)
                        Button("Send Feedback") {
                            print("[DEBUG] Feedback sent: \(feedbackText)")
                            showFeedback = false
                            feedbackText = ""
                        }
                        .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .navigationTitle("Send Feedback")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showFeedback = false
                            }
                        }
                    }
                }
            }
            // Logout Alert
            .alert("Are you sure you want to log out?", isPresented: $showLogoutAlert) {
                Button("Log out", role: .destructive) {
                    print("[DEBUG] User logged out")
                    authModel.signOut()
                }
                Button("Cancel", role: .cancel) {}
            }
            // Image Picker (placeholder)
            .sheet(isPresented: $showImagePicker) {
                VStack(spacing: 24) {
                    Text("Image picker coming soon")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Button("Close") {
                        showImagePicker = false
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Update Nickname
    private func updateNickname() {
        guard let uid = authModel.userProfile?.uid else { return }
        let trimmed = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Nickname cannot be empty."
            isSaving = false
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData(["nickname": trimmed]) { error in
            isSaving = false
            if let error = error {
                print("[DEBUG] Error updating nickname: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            } else {
                print("[DEBUG] Nickname updated in Firestore: \(trimmed)")
                authModel.userProfile?.nickname = trimmed
                showEdit = false
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView(authModel: AuthViewModel())
} 
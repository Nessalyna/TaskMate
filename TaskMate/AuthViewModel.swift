import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
final class AuthViewModel {
    var isAuthenticated: Bool = false
    var errorMessage: String? = nil
    var userProfile: UserProfile? = nil // Local user profile

    // MARK: - User Profile Model
    struct UserProfile: Codable {
        let uid: String
        let email: String
        var nickname: String
        var avatarURL: String?
    }

    // MARK: - Session Check
    func checkSession() {
        if let user = Auth.auth().currentUser {
            print("[DEBUG] User already signed in: \(user.uid)")
            isAuthenticated = true
            fetchUserProfile(uid: user.uid)
        } else {
            print("[DEBUG] No user session found")
            isAuthenticated = false
        }
    }

    // MARK: - Sign up with email and password
    func signUp(email: String, password: String, nickname: String, completion: @escaping (Bool) -> Void) {
        print("[DEBUG] Attempting sign up for: \(email)")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("[DEBUG] Sign up error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                completion(false)
            } else if let user = result?.user {
                print("[DEBUG] Sign up successful for: \(email)")
                self.isAuthenticated = true
                self.createUserProfile(uid: user.uid, email: email, nickname: nickname)
                completion(true)
            }
        }
    }

    // MARK: - Sign in with email and password
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        print("[DEBUG] Attempting sign in for: \(email)")
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("[DEBUG] Sign in error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                completion(false)
            } else if let user = result?.user {
                print("[DEBUG] Sign in successful for: \(email)")
                self.isAuthenticated = true
                self.fetchUserProfile(uid: user.uid)
                completion(true)
            }
        }
    }

    // MARK: - Sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("[DEBUG] User signed out")
            self.isAuthenticated = false
            self.userProfile = nil
        } catch {
            print("[DEBUG] Sign out error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Firestore: Create User Profile
    private func createUserProfile(uid: String, email: String, nickname: String) {
        let profile = UserProfile(uid: uid, email: email, nickname: nickname, avatarURL: nil)
        do {
            try Firestore.firestore().collection("users").document(uid).setData(from: profile) { error in
                if let error = error {
                    print("[DEBUG] Error saving user profile: \(error.localizedDescription)")
                } else {
                    print("[DEBUG] User profile created in Firestore for: \(uid)")
                    self.userProfile = profile
                }
            }
        } catch {
            print("[DEBUG] Error encoding user profile: \(error.localizedDescription)")
        }
    }

    // MARK: - Firestore: Fetch User Profile
    private func fetchUserProfile(uid: String) {
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("[DEBUG] Error fetching user profile: \(error.localizedDescription)")
                return
            }
            if let data = snapshot?.data() {
                do {
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let profile = try JSONDecoder().decode(UserProfile.self, from: json)
                    self.userProfile = profile
                    print("[DEBUG] User profile loaded: \(profile)")
                } catch {
                    print("[DEBUG] Error decoding user profile: \(error.localizedDescription)")
                }
            }
        }
    }
} 

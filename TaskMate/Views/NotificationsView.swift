import SwiftUI

struct NotificationsView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Notifications")
        }
    }
}

// MARK: - Preview
#Preview {
    NotificationsView()
} 
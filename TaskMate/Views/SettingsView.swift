import SwiftUI

struct SettingsView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
} 
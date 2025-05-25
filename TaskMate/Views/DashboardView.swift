import SwiftUI

struct DashboardView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Dashboard")
        }
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
} 
import SwiftUI

struct RootScreen: View {
    var body: some View {
        LoginScreen(state: .init())
    }
}

#Preview {
    RootScreen()
}

import SwiftUI

struct NotificationScreen: View {
    @State var state: NotificationScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: NotificationScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Color.yellow
        }
    }
}

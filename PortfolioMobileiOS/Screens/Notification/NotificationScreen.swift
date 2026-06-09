import SwiftUI

struct NotificationScreen: View {
    @State var state: NotificationScreenState
    init(state: NotificationScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Color.yellow
        }
    }
}

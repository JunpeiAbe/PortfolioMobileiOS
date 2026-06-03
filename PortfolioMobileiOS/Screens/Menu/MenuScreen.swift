import SwiftUI

struct MenuScreen: View {
    @State var state: MenuScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: MenuScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Color.green
        }
    }
}

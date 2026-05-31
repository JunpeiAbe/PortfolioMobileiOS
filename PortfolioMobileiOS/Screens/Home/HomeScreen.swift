import SwiftUI

struct HomeScreen: View {
    @State var state: HomeScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: HomeScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            EmptyView()
        }
        .screenBackground()
        .toolBar(
            title: "Home",
            isLeftButtonHidden: true,
            leftButtonAction: {},
            rightButtonAction: {})
    }
}

#Preview {
    @Previewable var state: HomeScreenState = .init()
    HomeScreen(state: state)
}

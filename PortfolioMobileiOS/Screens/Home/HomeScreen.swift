import SwiftUI

struct HomeScreen: View {
    @State var state: HomeScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: HomeScreenState) {
        self.state = state
    }
    
    var body: some View {
        EmptyView()
    }
}

#Preview {
    @Previewable var state: HomeScreenState = .init()
    HomeScreen(state: state)
}

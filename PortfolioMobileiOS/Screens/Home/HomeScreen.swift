import SwiftUI

struct HomeScreen: View {
    @State var state: HomeScreenState
    @Environment(\.loading) var loading
    init(state: HomeScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            EmptyView()
        }
        .screenBackground()
        .onChange(of: state.loadingState.isLoading) { _, newValue in
            if newValue {
                loading.show()
            } else {
                loading.hide()
            }
        }
    }
}

#Preview {
    @Previewable var state: HomeScreenState = AppDependency.debug().makeHomeState()
    HomeScreen(state: state)
}

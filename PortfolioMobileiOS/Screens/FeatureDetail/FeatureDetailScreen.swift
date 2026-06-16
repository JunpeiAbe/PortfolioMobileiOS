import SwiftUI

struct FeatureDetailScreen: View {
    @State var state: FeatureDetailScreenState
    @Environment(\.loading) var loading
    init(state: FeatureDetailScreenState) {
        self.state = state
    }
    var body: some View {
        VStack(spacing: .zero) {
                emptyContent()
        }
        .screenBackground()
        .toolBar(
            title: state.feature.title,
            leftButtonAction: {
                state.backButtonPressed()
            },
            logoutButtonAction: {},
            helpButtonAction: {}
        )
        .onAppearOnce {
            state.onAppear()
        }
        .onChange(of: state.loadingState.isLoading) { _, newValue in
            if newValue {
                loading.show()
            } else {
                loading.hide()
            }
        }
    }
    
    private struct emptyContent: View {
        var body: some View {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 80))
                .foregroundStyle(.primaryWhite)
        }
    }
}

#Preview {
    let dependency: AppDependency = .debug(keychainClient: StubKeychainClient())
    FeatureDetailScreen(state: dependency.makeFeatureDetailState(.init(id: UUID().uuidString, title: "Location", category: .location)))
}


import SwiftUI

struct FeaturesScreen: View {
    @State var state: FeaturesScreenState
    @Environment(\.loading) var loading
    init(state: FeaturesScreenState) {
        self.state = state
    }
    var body: some View {
        VStack(spacing: .zero) {
            if !state.isFeaturesEmpty {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(state.features) { feature in
                            FeatureRow(feature: feature)
                                .task {
                                    await state.loadMoreIfNeeded(currentFeature: feature)
                                }
                        }
                    }
                    .padding(16)
                }
            } else {
                emptyContent()
            }
        }
        .screenBackground()
        .taskOnce {
            await state.onAppear()
        }
        .refreshable {
            await state.refreshFeatures()
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
    FeaturesScreen(state: dependency.makeFeaturesState())
}

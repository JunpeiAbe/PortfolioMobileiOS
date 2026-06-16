import Foundation

@MainActor
@Observable
final class FeatureDetailScreenState {
    var loadingState: LoadingState = .idle
    var appRouter: AppRouter
    var alertContent: PresentAlert?
    var feature: Feature {
        featuresStore.selectedFeature
        ?? .init(id: .init(), title: "FeatureDetail", category: .unknown)
    }
    private let featuresStore: FeaturesStore
    
    init(
        appRouter: AppRouter,
        featuresStore: FeaturesStore
    ) {
        self.appRouter = appRouter
        self.featuresStore = featuresStore
    }
    
    func onAppear() {}
    
    func backButtonPressed() {
        appRouter.pop(.main)
    }
}

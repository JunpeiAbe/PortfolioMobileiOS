import Foundation

@MainActor
@Observable
final class FeaturesScreenState {
    var loadingState: LoadingState = .idle
    var appRouter: AppRouter
    var alertContent: PresentAlert?
    var features: [Feature] = []
    private let featuresStore: FeaturesStore
    private(set) var isLoadingMore = false
    var isFeaturesEmpty: Bool {
        features.isEmpty
    }
    
    init(
        appRouter: AppRouter,
        featuresStore: FeaturesStore
    ) {
        self.appRouter = appRouter
        self.featuresStore = featuresStore
    }
    
    func onAppear() async {
        loadingState = .loading
        defer {
            loadingState = .idle
        }
        do {
            try await featuresStore.fetchFeatures()
            let features = featuresStore.features
            self.features.append(contentsOf: features)
        } catch let error as APIClientError {
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
        }
    }
    
    func refreshFeatures() async {
        features = []
        await onAppear()
    }
    
    func loadMoreIfNeeded(currentFeature: Feature) async {
        guard let nextCursor = featuresStore.nextCursor else {
            return
        }
        guard shouldLoadMore(currentFeature: currentFeature) else {
            return
        }
        isLoadingMore = true
        defer {
            isLoadingMore = false
        }
        
        do {
            try await featuresStore.loadMore(nextCursor: nextCursor)
            self.features = featuresStore.features
        } catch let error as APIClientError {
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
        }
    }
    
    private func shouldLoadMore(currentFeature: Feature) -> Bool {
        currentFeature.id == features.last?.id
    }
    
    func featureRowPressed(feature: Feature) {
        appRouter.push(.featureDetail(feature))
    }
}


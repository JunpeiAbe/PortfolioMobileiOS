import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("FeatureDetailScreenState", .serialized)
struct FeatureDetailScreenStateTests {
    // Feature詳細が選択Featureを表示し、戻る操作でMainまで戻ることを検証する。
    @Test func featureDetail() {
        let router = DefaultAppRouter()
        router.push(.main)
        router.push(.featureDetail(TestFixtures.feature()))
        let store = FeaturesStoreSpy()
        store.selectedFeature = TestFixtures.feature("selected", title: "Selected")
        let state = FeatureDetailScreenState(appRouter: router, featuresStore: store)
        #expect(state.feature.id == "selected")
        state.backButtonPressed()
        #expect(router.pushDestinations == [.main])
    }
}

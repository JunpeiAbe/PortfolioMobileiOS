import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("FeaturesScreenState", .serialized)
struct FeaturesScreenStateTests {
    // Feature一覧の初回取得、空判定、Loading終了を検証する。
    @Test func featuresOnAppear() async {
        let store = FeaturesStoreSpy()
        store.features = [TestFixtures.feature("1"), TestFixtures.feature("2")]
        let state = FeaturesScreenState(appRouter: DefaultAppRouter(), featuresStore: store)
        await state.onAppear()
        #expect(state.features.map(\.id) == ["1", "2"])
        #expect(!state.isFeaturesEmpty)
        #expect(state.loadingState == .idle)
    }

    // Feature一覧の最後の要素でのみ追加取得することを検証する。
    @Test func featuresLoadMoreBoundary() async {
        let store = FeaturesStoreSpy()
        store.features = [TestFixtures.feature("1"), TestFixtures.feature("2")]
        store.nextCursor = "next"
        let state = FeaturesScreenState(appRouter: DefaultAppRouter(), featuresStore: store)
        await state.onAppear()
        await state.loadMoreIfNeeded(currentFeature: state.features[0])
        #expect(store.loadCursors.isEmpty)
        await state.loadMoreIfNeeded(currentFeature: state.features[1])
        #expect(store.loadCursors == ["next"])
        #expect(!state.isLoadingMore)
    }

    // Feature押下で選択したFeatureを含む詳細Destinationへ遷移することを検証する。
    @Test func featureSelection() {
        let router = DefaultAppRouter()
        let state = FeaturesScreenState(appRouter: router, featuresStore: FeaturesStoreSpy())
        let feature = TestFixtures.feature()
        state.featureRowPressed(feature: feature)
        #expect(router.pushDestinations == [.featureDetail(feature)])
    }
}

import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("NotificationScreenState", .serialized)
struct NotificationScreenStateTests {
    // Notice一覧の初回取得とRefreshによる置換を検証する。
    @Test func noticesOnAppearAndRefresh() async {
        let store = NoticeStoreSpy()
        store.notices = [TestFixtures.notice("1")]
        let state = NotificationScreenState(appRouter: DefaultAppRouter(), noticeStore: store)
        await state.onAppear()
        #expect(state.notices.map(\.id) == ["1"])
        store.notices = [TestFixtures.notice("2")]
        await state.refreshNotices()
        #expect(state.notices.map(\.id) == ["2"])
        #expect(store.fetchCallCount == 2)
    }

    // Notice一覧の最後の要素でのみ追加取得することを検証する。
    @Test func noticesLoadMoreBoundary() async {
        let store = NoticeStoreSpy()
        store.notices = [TestFixtures.notice("1"), TestFixtures.notice("2")]
        store.nextCursor = "next"
        let state = NotificationScreenState(appRouter: DefaultAppRouter(), noticeStore: store)
        await state.onAppear()
        await state.loadMoreIfNeeded(currentNotice: state.notices[0])
        #expect(store.loadCursors.isEmpty)
        await state.loadMoreIfNeeded(currentNotice: state.notices[1])
        #expect(store.loadCursors == ["next"])
        #expect(!state.isLoadingMore)
    }
}

import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("MainScreenState", .serialized)
struct MainScreenStateTests {
    // Logout成功時にLoginまでNavigation履歴を戻すことを検証する。
    @Test func logout() async throws {
        let router = DefaultAppRouter()
        router.push(.login)
        router.push(.main)
        let authentication = AuthenticationStoreSpy()
        let state = MainScreenState(appRouter: router, authenticationStore: authentication)
        state.logoutButtonPressed()
        try await waitForTasks()
        #expect(authentication.logoutCallCount == 1)
        #expect(router.pushDestinations == [.login])
    }
}

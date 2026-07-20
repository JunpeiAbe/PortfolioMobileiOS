import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("SplashScreenState", .serialized)
struct SplashScreenStateTests {
    // 初回起動で通知許可、Terminal ID生成、アプリ情報取得、Login遷移を行うことを検証する。
    @Test func splashWithoutSession() async {
        let router = DefaultAppRouter()
        let push = PushNotificationStoreSpy()
        let information = AppInformationStoreSpy()
        let authentication = AuthenticationStoreSpy()
        let state = SplashScreenState(appRouter: router, pushNotificationStore: push, appInformationStore: information, authenticationStore: authentication)
        await state.onAppear()
        #expect(push.authorizationCallCount == 1)
        #expect(authentication.saveTerminalIDCallCount == 1)
        #expect(information.callCount == 1)
        #expect(router.pushDestinations == [.login])
    }

    // Refresh成功時にLoginを履歴へ置いた後Mainへ遷移し、Push Tokenを登録することを検証する。
    @Test func splashWithSession() async {
        let router = DefaultAppRouter()
        let push = PushNotificationStoreSpy()
        let authentication = AuthenticationStoreSpy()
        authentication.refreshToken = "refresh"
        authentication.terminalID = "device"
        let state = SplashScreenState(appRouter: router, pushNotificationStore: push, appInformationStore: AppInformationStoreSpy(), authenticationStore: authentication)
        await state.onAppear()
        #expect(authentication.refreshArguments == ["refresh"])
        #expect(push.deviceIDs == ["device"])
        #expect(router.pushDestinations == [.login, .main])
    }
}

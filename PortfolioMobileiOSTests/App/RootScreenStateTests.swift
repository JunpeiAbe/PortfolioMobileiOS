import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("RootScreenState", .serialized)
struct RootScreenStateTests {
    // メンテナンスと強制アップデートの状態に応じてAlertを設定することをまとめて検証する。
    @Test(arguments: [(true, false, "メンテナンス中"), (false, true, "アップデート")])
    func checkAppStatus(isMaintenance: Bool, needsUpdate: Bool, titleFragment: String) async {
        let information = AppInformationStoreSpy()
        information.isMaintenance = isMaintenance
        information.needsForceUpdate = needsUpdate
        let state = RootScreenState(appInformationStore: information, authenticationStore: AuthenticationStoreSpy())
        await state.checkAppStatus()
        #expect(state.alertContent?.title.contains(titleFragment) == true)
    }

    // Refresh Tokenがある場合だけToken更新し、多重実行フラグを元に戻すことを検証する。
    @Test(arguments: [nil, "refresh"] as [String?])
    func refreshAccessToken(token: String?) async {
        let authentication = AuthenticationStoreSpy()
        authentication.refreshToken = token
        let state = RootScreenState(appInformationStore: AppInformationStoreSpy(), authenticationStore: authentication)
        await state.refreshAccessTokenIfNeeded()
        #expect(authentication.refreshArguments == (token.map { [$0] } ?? []))
        #expect(!state.isRefreshingAccessToken)
    }
}

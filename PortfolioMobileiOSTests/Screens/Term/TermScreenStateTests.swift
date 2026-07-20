import Foundation
import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("TermScreenState", .serialized)
struct TermScreenStateTests {
    // チェック状態に応じてAgreeボタンの活性状態が切り替わることを検証する。
    @Test func termCheckToggle() {
        let state = TermScreenState(appRouter: DefaultAppRouter(), appInformationStore: AppInformationStoreSpy(), authenticationStore: AuthenticationStoreSpy())
        #expect(state.isAgreeButtonDisabled)
        state.checkButtonPressed()
        #expect(!state.isAgreeButtonDisabled)
        state.checkButtonPressed()
        #expect(state.isAgreeButtonDisabled)
    }

    // 認証情報とアプリ情報が揃う場合に利用規約URLを設定することを検証する。
    @Test func termURL() async {
        let information = AppInformationStoreSpy()
        information.appInformation = .init(isMaintenance: false, iOSMinAppVersion: nil, appTermURL: "https://example.com/terms", appTermVersion: "1", qaURL: nil)
        let authentication = AuthenticationStoreSpy()
        authentication.mailAddress = "user@example.com"
        authentication.accessToken = "access"
        let state = TermScreenState(appRouter: DefaultAppRouter(), appInformationStore: information, authenticationStore: authentication)
        await state.onAppear()
        #expect(state.appTermURL == URL(string: "https://example.com/terms"))
        #expect(state.loadingState == .idle)
    }

    // Agree成功時にversionをStoreへ渡してMainへ遷移することを検証する。
    @Test func agreeTermSuccess() async throws {
        let router = DefaultAppRouter()
        let information = AppInformationStoreSpy()
        information.appInformation = .init(isMaintenance: false, iOSMinAppVersion: nil, appTermURL: nil, appTermVersion: "2", qaURL: nil)
        let authentication = AuthenticationStoreSpy()
        authentication.accessToken = "access"
        let state = TermScreenState(appRouter: router, appInformationStore: information, authenticationStore: authentication)
        state.isChecked = true
        state.agreeButtonPressed()
        try await waitForTasks()
        #expect(authentication.agreeVersions == ["2"])
        #expect(router.pushDestinations == [.main])
    }
}

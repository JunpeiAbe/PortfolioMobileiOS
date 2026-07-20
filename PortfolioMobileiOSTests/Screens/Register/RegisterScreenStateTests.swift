import Foundation
import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("RegisterScreenState", .serialized)
struct RegisterScreenStateTests {
    // 確認パスワードの空・文字数・形式・不一致・一致をまとめて検証する。
    @Test(arguments: [
        ("", ""),
        ("Abc1!", "パスワードは8〜32桁で入力してください。"),
        ("abcdefgh", "パスワードの形式で入力してください。"),
        ("Xbcdef1!", "パスワードとパスワード(確認)が一致しません。"),
        ("Abcdef1!", "")
    ])
    func confirmPasswordValidation(input: String, expectedError: String) {
        let state = makeState()
        state.passwordText = "Abcdef1!"
        state.onConfirmPasswordTextSubmit(input)
        #expect(state.confirmPasswordErrorMessage == expectedError)
    }

    // 3項目が正常な場合だけSign Upボタンを有効にすることを検証する。
    @Test func registerButtonAvailability() {
        let state = makeState()
        state.onEmailTextSubmit("user@example.com")
        state.onPasswordTextSubmit("Abcdef1!")
        state.onConfirmPasswordTextSubmit("Abcdef1!")
        #expect(!state.isRegisterButtonDisabled)
    }

    // Register成功時にPush Tokenを登録してTermsへ遷移することを検証する。
    @Test func registerSuccess() async throws {
        let router = DefaultAppRouter()
        let authentication = AuthenticationStoreSpy()
        authentication.terminalID = "device"
        let push = PushNotificationStoreSpy()
        let state = RegisterScreenState(appRouter: router, authenticationStore: authentication, pushNotificationStore: push)
        state.emailText = "user@example.com"
        state.passwordText = "Abcdef1!"
        state.confirmPasswordText = "Abcdef1!"
        state.registerButtonPressed()
        try await waitForTasks()
        #expect(authentication.registerArguments.count == 1)
        #expect(push.deviceIDs == ["device"])
        #expect(router.pushDestinations == [.term])
    }

    // 戻る操作でNavigation履歴を1件戻すことを検証する。
    @Test func back() {
        let router = DefaultAppRouter()
        router.push(.register)
        let state = makeState(router: router)
        state.backButtonPressed()
        #expect(router.pushDestinations.isEmpty)
    }

    private func makeState(router: DefaultAppRouter = DefaultAppRouter()) -> RegisterScreenState {
        RegisterScreenState(appRouter: router, authenticationStore: AuthenticationStoreSpy(), pushNotificationStore: PushNotificationStoreSpy())
    }
}

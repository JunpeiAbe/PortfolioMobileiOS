import Foundation
import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("LoginScreenState", .serialized)
struct LoginScreenStateTests {
    struct FieldCase: Sendable {
        let input: String
        let expectedError: String
    }

    // メール入力の空・文字数・形式・正常値の境界をまとめて検証する。
    @Test(arguments: [
        FieldCase(input: "", expectedError: ""),
        FieldCase(input: "a@b.c", expectedError: "メールアドレスは6〜64桁で入力してください。"),
        FieldCase(input: String(repeating: "a", count: 65), expectedError: "メールアドレスは6〜64桁で入力してください。"),
        FieldCase(input: "invalid-address", expectedError: "メールアドレスの形式で入力してください。"),
        FieldCase(input: "user@example.com", expectedError: "")
    ])
    func emailValidation(case value: FieldCase) {
        let state = makeState()
        state.onEmailTextSubmit(value.input)
        #expect(state.emailErrorMessage == value.expectedError)
    }

    // パスワード入力の空・文字数・形式・正常値の境界をまとめて検証する。
    @Test(arguments: [
        FieldCase(input: "", expectedError: ""),
        FieldCase(input: "Abc1!", expectedError: "パスワードは8〜32桁で入力してください。"),
        FieldCase(input: String(repeating: "A", count: 33), expectedError: "パスワードは8〜32桁で入力してください。"),
        FieldCase(input: "abcdefgh", expectedError: "パスワードの形式で入力してください。"),
        FieldCase(input: "Abcdef1!", expectedError: "")
    ])
    func passwordValidation(case value: FieldCase) {
        let state = makeState()
        state.onPasswordTextSubmit(value.input)
        #expect(state.passwordErrorMessage == value.expectedError)
    }

    // 入力許可外の全角文字や記号を除去することを検証する。
    @Test func allowedCharacterFiltering() {
        let state = makeState()
        state.onEmailTextChange("user日本語@example.com")
        state.onPasswordTextChange("Abc+def1!日本語")
        #expect(state.emailText == "user@example.com")
        #expect(state.passwordText == "Abcdef1!")
    }

    // 必須項目とValidation結果に応じてLoginボタンの活性状態が変わることを検証する。
    @Test func loginButtonAvailability() {
        let state = makeState()
        #expect(state.isLoginButtonDisabled)
        state.onEmailTextSubmit("user@example.com")
        state.onPasswordTextSubmit("Abcdef1!")
        #expect(!state.isLoginButtonDisabled)
    }

    // Sign Up押下でRegisterへ遷移し、Focus状態を保持することを検証する。
    @Test func signupAndFocus() {
        let router = DefaultAppRouter()
        let state = makeState(router: router)
        state.onFocusedFieldChange(.email)
        state.signupButtonPressed()
        #expect(state.focusingField == .email)
        #expect(router.pushDestinations == [.register])
    }

    // Login成功時に未同意ならTerms、同意済みならMainへ遷移することをまとめて検証する。
    @Test(arguments: [false, true])
    func loginSuccess(appTermsAgreed: Bool) async throws {
        let router = DefaultAppRouter()
        let authentication = AuthenticationStoreSpy()
        authentication.authSession = .init(accessToken: "access", refreshToken: "refresh", appTermsAgreed: appTermsAgreed)
        authentication.terminalID = "device"
        let push = PushNotificationStoreSpy()
        let state = LoginScreenState(appRouter: router, authenticationStore: authentication, pushNotificationStore: push)
        state.emailText = "user@example.com"
        state.passwordText = "Abcdef1!"
        state.loginButtonPressed()
        try await waitForTasks()
        #expect(authentication.loginArguments.count == 1)
        #expect(push.deviceIDs == ["device"])
        #expect(router.pushDestinations == [appTermsAgreed ? .main : .term])
        #expect(state.loadingState == .idle)
    }

    private func makeState(router: DefaultAppRouter = DefaultAppRouter()) -> LoginScreenState {
        LoginScreenState(appRouter: router, authenticationStore: AuthenticationStoreSpy(), pushNotificationStore: PushNotificationStoreSpy())
    }
}

import Foundation

@MainActor
@Observable
final class RegisterScreenState {
    var emailText: String = .init()
    var passwordText: String = .init()
    var confirmPasswordText: String = .init()
    var emailErrorMessage: String = .init()
    var passwordErrorMessage: String = .init()
    var confirmPasswordErrorMessage: String = .init()
    var loadingState: LoadingState = .idle
    /// フォーカスが当たっている入力欄
    private(set) var focusingField: FocusableField?
    
    var isEmailErrorMessageHidden: Bool {
        emailErrorMessage.isEmpty
    }
    
    var isPasswordErrorMessageHidden: Bool {
        passwordErrorMessage.isEmpty
    }
    
    var isConfirmPasswordErrorMessageHidden: Bool {
        confirmPasswordErrorMessage.isEmpty
    }
    
    var isRegisterButtonDisabled: Bool {
        emailText.isEmpty
        || passwordText.isEmpty
        || confirmPasswordText.isEmpty
        || !isEmailErrorMessageHidden
        || !isPasswordErrorMessageHidden
        || !isConfirmPasswordErrorMessageHidden
        || loadingState == .loading
    }
    
    var appRouter: AppRouter
    var authenticationStore: AuthenticationStore
    private let pushNotificationStore: PushNotificationStore
    var alertContent: PresentAlert?
    
    init(
        appRouter: AppRouter,
        authenticationStore: AuthenticationStore,
        pushNotificationStore: PushNotificationStore
    ) {
        self.appRouter = appRouter
        self.authenticationStore = authenticationStore
        self.pushNotificationStore = pushNotificationStore
    }
    
    func onEmailTextSubmit(_ text: String) {
        emailText = text
        // 入力文字列が空かどうか
        guard !text.isEmpty else {
            emailErrorMessage = .init()
            return
        }
        // 入力文字数上限または下限を満たしているかどうか
        guard text.count >= 6, text.count <= 64 else {
            emailErrorMessage = "メールアドレスは6〜64桁で入力してください。"
            return
        }
        // メールアドレスのフォーマットに該当するか
        guard MailAddressValidator().isValid(text) else {
            emailErrorMessage = "メールアドレスの形式で入力してください。"
            return
        }
        emailErrorMessage = .init()
    }
    
    func onEmailTextChange(_ text: String) {
        // 指定文字種と一致するもののみ許可する
        validateAllowCharacters(text, field: .email, regex: .emailSymbols)
    }
    
    func onPasswordTextSubmit(_ text: String) {
        passwordText = text
        // 入力文字列が空かどうか
        guard !text.isEmpty else {
            passwordErrorMessage = .init()
            return
        }
        // 入力文字数上限または下限を満たしているかどうか
        guard text.count >= 8, text.count <= 32 else {
            passwordErrorMessage = "パスワードは8〜32桁で入力してください。"
            return
        }
        // パスワードのフォーマットに該当するか
        guard PasswordValidator().isValid(text) else {
            passwordErrorMessage = "パスワードの形式で入力してください。"
            return
        }
        // パスワードとパスワード(確認)が一致するかどうか
        // パスワード(確認)が未入力の場合はスキップ
        if !confirmPasswordText.isEmpty {
            onConfirmPasswordTextSubmit(confirmPasswordText)
        }
        passwordErrorMessage = .init()
    }
    
    func onPasswordTextChange(_ text: String) {
        // 指定文字種と一致するもののみ許可する
        validateAllowCharacters(text, field: .password, regex: .passwordSymbols)
    }
    
    func onConfirmPasswordTextSubmit(_ text: String) {
        confirmPasswordText = text
        // 入力文字列が空かどうか
        guard !text.isEmpty else {
            confirmPasswordErrorMessage = .init()
            return
        }
        // 入力文字数上限または下限を満たしているかどうか
        guard text.count >= 8, text.count <= 32 else {
            confirmPasswordErrorMessage = "パスワードは8〜32桁で入力してください。"
            return
        }
        // パスワード(確認)のフォーマットに該当するか
        guard PasswordValidator().isValid(text) else {
            confirmPasswordErrorMessage = "パスワードの形式で入力してください。"
            return
        }
        // パスワードとパスワード(確認)が一致するかどうか
        // パスワードが未入力の場合はスキップ
        if !passwordText.isEmpty {
            guard passwordText == confirmPasswordText else {
                confirmPasswordErrorMessage = "パスワードとパスワード(確認)が一致しません。"
                return
            }
        }
        confirmPasswordErrorMessage = .init()
    }
    
    func onConfirmPasswordTextChange(_ text: String) {
        // 指定文字種と一致するもののみ許可する
        validateAllowCharacters(text, field: .confirmPassword, regex: .passwordSymbols)
    }
    
    func registerButtonPressed() {
        onEmailTextChange(emailText)
        onPasswordTextChange(passwordText)
        onConfirmPasswordTextSubmit(confirmPasswordText)
        guard !isRegisterButtonDisabled else { return }
        loadingState = .loading
        Task {
            defer {
                loadingState = .idle
            }
            do {
                // ユーザー登録
                try await authenticationStore
                    .register(
                        mailAddress: emailText,
                        password: passwordText
                    )
                if let deviceID = authenticationStore.terminalID {
                    do {
                        try await pushNotificationStore.registerToken(deviceID: deviceID)
                    } catch {
                        print("Failed to register FCM token:", error)
                    }
                }
                // 規約同意画面に遷移
                appRouter.push(.term)
            } catch let error as APIClientError {
                // TODO: error handling
                switch error {
                    // 通信エラーの場合
                case .notConnectedToInternet: break
                default: break
                }
            } catch {
                // TODO: error handling
            }
        }
        loadingState = .idle
    }
    
    func backButtonPressed() {
        appRouter.pop()
    }
    
    func onFocusedFieldChange(_ field: FocusableField?) {
        focusingField = field
    }
    
    /// 入力許可文字種のチェック
    func validateAllowCharacters(_ text: String, field: FocusableField, regex: AllowedCharacterRegex) {
        guard let regex = try? NSRegularExpression(pattern: regex.pattern) else { return }
        let allowText = text.filter {
            let range = NSRange(location: .zero, length: String($0).count)
            return regex.firstMatch(in: String($0), range: range) != nil
        }
        switch field {
        case .email:
            emailText = allowText
        case .password:
            passwordText = allowText
        case .confirmPassword:
            confirmPasswordText = allowText
        }
    }
}

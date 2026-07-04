import Foundation

@MainActor
@Observable
final class LoginScreenState {
    
    var emailText: String = .init()
    var passwordText: String = .init()
    var emailErrorMessage: String = .init()
    var passwordErrorMessage: String = .init()
    var loadingState: LoadingState = .idle
    /// フォーカスが当たっている入力欄
    private(set) var focusingField: FocusableField?
    
    var isEmailErrorMessageHidden: Bool {
        emailErrorMessage.isEmpty
    }
    
    var isPasswordErrorMessageHidden: Bool {
        passwordErrorMessage.isEmpty
    }
    
    var isLoginButtonDisabled: Bool {
        emailText.isEmpty
        || passwordText.isEmpty
        || !isEmailErrorMessageHidden
        || !isPasswordErrorMessageHidden
        || loadingState == .loading
    }
    
    private let appRouter: AppRouter
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    
    init(
        appRouter: AppRouter,
        authenticationStore: AuthenticationStore
    ) {
        self.appRouter = appRouter
        self.authenticationStore = authenticationStore
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
        // メールアドレスのフォーマットに該当するか
        guard PasswordValidator().isValid(text) else {
            passwordErrorMessage = "パスワードの形式で入力してください。"
            return
        }
        passwordErrorMessage = .init()
    }
    
    func onPasswordTextChange(_ text: String) {
        // 指定文字種と一致するもののみ許可する
        validateAllowCharacters(text, field: .password, regex: .passwordSymbols)
    }
    
    func loginButtonPressed() {
        onEmailTextSubmit(emailText)
        onPasswordTextSubmit(passwordText)
        guard !isLoginButtonDisabled else { return }
        loadingState = .loading
        Task {
            defer {
                loadingState = .idle
            }
            do {
                try await authenticationStore
                    .login(
                        mailAddress: emailText,
                        password: passwordText,
                        deviceToken: .init()
                    )
                // 規約同意確認
                if authenticationStore.appTermsAgreed {
                    appRouter.push(.main)
                } else {
                    appRouter.push(.term)
                }
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
    }
    
    func signupButtonPressed() {
        appRouter.push(.register)
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
            break
        }
    }
}

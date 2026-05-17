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
        guard isMailAddressFormat(text) else {
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
        guard isPasswordFormat(text) else {
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
        guard !isLoginButtonDisabled else { return }
        loadingState = .loading
        onEmailTextSubmit(emailText)
        onPasswordTextSubmit(passwordText)
        loadingState = .idle
    }
    
    func signUpButtonPressed() {
        
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
    /// パスワードのフォーマットに沿っているかどうか
    func isPasswordFormat(_ text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: AllowedCharacterRegex.passwordPolicy.pattern) else { return false }
        guard regex.firstMatch(in: text, range: NSRange(0..<text.count)) != nil else {
            return false
        }
        return true
    }
    
    /// メールアドレスのフォーマットに沿っているか
    func isMailAddressFormat(_ text: String) -> Bool {
        // 未入力でないこと
        guard !text.isEmpty else { return false }
        let atSign: String = "@"
        let period: Character = "."
        let consececutivePeriods = ".."
        // @の前後に文字列が存在すること(// @が1つだけ含まれていること)
        let parts = text.components(separatedBy: atSign)
        guard parts.count == 2 else { return false }
        
        let localPart = parts[0]
        let domainPart = parts[1]
        // @の前後に文字列があること
        guard !localPart.isEmpty else { return false }
        guard !domainPart.isEmpty else { return false }
        // ドメイン部に.が含まれていること
        guard domainPart.contains(".") else { return false }
        // ドメイン部で.が連続していないこと
        guard !domainPart.contains("..") else { return false }
        // ドメイン部の先頭・末尾が . ではないこと
        guard !domainPart.hasPrefix(".") else { return false }
        guard !domainPart.hasSuffix(".") else { return false }
        return true
    }
}

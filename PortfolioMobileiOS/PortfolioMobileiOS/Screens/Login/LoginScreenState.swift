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
        guard !text.isEmpty else {
            // 未入力チェック
            return false
        }
        // 文字列：「@」
        let AT_SIGN = Character("@")

        // 文字列：「.」
        let PERIOD = Character(".")

        // 文字列：「..」
        let CONSECUTIVE_PERIOD = ".."

        if (text.contains(AT_SIGN)) {
            if (text.first == AT_SIGN) {
                // 先頭が「@」の場合、エラー
                return false
            } else {
                if (text.filter({ $0 == AT_SIGN }).count < 2) {
                    let ary1 = text.split(separator: AT_SIGN)
                    if (ary1[1].contains(PERIOD)) {
                        let ary2 = ary1[1]
                        if (ary1[1].contains(CONSECUTIVE_PERIOD)) {
                            // 「@」以降で「.」が連続する場合、エラー
                            return false
                        }
                        if (PERIOD == ary2.first) {
                            // 「@」直後が「.」の場合、エラー
                            return false
                        }
                        if (PERIOD == ary2.last) {
                            // 最後の「.」以降に許容文字が存在しない場合、エラー
                            return false
                        }
                    } else {
                        // 「@」以降に「.」を含まない場合、エラー
                        return false
                    }
                } else {
                    // 「@」が複数含まれている場合、エラー
                    return false
                }
            }
        } else {
            // 「@」が含まれていない場合、エラー
            return false
        }
        return true
    }
}


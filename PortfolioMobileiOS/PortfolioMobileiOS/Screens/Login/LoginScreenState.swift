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
    
    func validateEmail() {}
    
    func validatePassword() {}
    
    func loginButtonPressed() {
        guard !isLoginButtonDisabled else { return }
        loadingState = .loading
    }
    
    func signUpButtonPressed() {
        
    }
    
    func onFocusedFieldChange(_ field: FocusableField?) {
        focusingField = field
    }
}


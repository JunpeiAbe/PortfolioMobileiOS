import SwiftUI

struct LoginScreen: View {
    
    @State var state: LoginScreenState
    @FocusState var focusedField: FocusableField?
    init(state: LoginScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack(alignment: .center, spacing: .zero) {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Mail")
                    .headlineFont()
                    .foregroundStyle(.black)
                MailTextField(
                    text: Bindable(state).emailText,
                    onSubmit: { text in
                        // TODO
                    },
                    onChange: { text in
                        // TODO
                    }
                )
                .focused($focusedField, equals: .email)
                Text(state.emailErrorMessage)
                    .captionFont()
                    .foregroundStyle(.red)
                    .hidden(state.isEmailErrorMessageHidden)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .headlineFont()
                    .foregroundStyle(.black)
                PasswordTextField(
                    text: Bindable(state).passwordText,
                    onSubmit: { text in
                        // TODO
                    },
                    onChange: { text in
                        // TODO
                    }
                )
                .focused($focusedField, equals: .password)
                Text(state.passwordErrorMessage)
                    .captionFont()
                    .foregroundStyle(.red)
                    .hidden(state.isPasswordErrorMessageHidden)
            }
            
            Button("Login") {
                state.loginButtonPressed()
            }
            .buttonStyle(
                .filled(
                    backgroundColor: state.isLoginButtonDisabled ? Color.gray : Color.main
                )
            )
            .headlineFont()
            .disabled(state.isLoginButtonDisabled)
            .frame(height: 48)
            
            HStack(spacing: .zero) {
                Spacer()
                Button("To Sign Up") {
                    state.signUpButtonPressed()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.blue)
                .bodyFont()
            }
            
            Spacer()
        }
        .padding(16)
        .screenBackground(dismissing: $focusedField)
        .onChange(of: state.focusingField) { oldField, newField in
            // viewStateのfocusingFieldを更新時にViewのfocusedFieldを更新
            focusedField = newField
            if newField == nil,
               oldField == FocusableField.email {
               // TDOD
            }
            
            if newField == nil,
               oldField == FocusableField.password {
                // TDOD
            }
        }
        .onChange(of: focusedField) { _, newFocusedField in
            state.onFocusedFieldChange(newFocusedField)
        }
    }
}

#Preview {
    @Previewable var state: LoginScreenState = .init()
    LoginScreen(state: state)
}

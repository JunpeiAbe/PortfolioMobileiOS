import SwiftUI

struct RegisterScreen: View {
    
    @State var state: RegisterScreenState
    @FocusState var focusedField: FocusableField?
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: RegisterScreenState) {
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
                    isError: !state.isEmailErrorMessageHidden,
                    isFocused: focusedField == .email,
                    onSubmit: { text in
                        print("email text submit")
                        state.onEmailTextSubmit(text)
                    },
                    onChange: { text in
                        print("email text change")
                        state.onEmailTextChange(text)
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
                    isError: !state.isPasswordErrorMessageHidden,
                    isFocused: focusedField == .password,
                    onSubmit: { text in
                        print("password text submit")
                        state.onPasswordTextSubmit(text)
                    },
                    onChange: { text in
                        print("password text change")
                        state.onPasswordTextChange(text)
                    }
                )
                .focused($focusedField, equals: .password)
                Text(state.passwordErrorMessage)
                    .captionFont()
                    .foregroundStyle(.red)
                    .hidden(state.isPasswordErrorMessageHidden)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password(Confirm)")
                    .headlineFont()
                    .foregroundStyle(.black)
                PasswordTextField(
                    text: Bindable(state).confirmPasswordText,
                    isError: !state.isConfirmPasswordErrorMessageHidden,
                    isFocused: focusedField == .confirmPassword,
                    onSubmit: { text in
                        print("confirm password text submit")
                        state.onConfirmPasswordTextSubmit(text)
                    },
                    onChange: { text in
                        print("confirm password text change")
                        state.onConfirmPasswordTextChange(text)
                    }
                )
                .focused($focusedField, equals: .confirmPassword)
                Text(state.confirmPasswordErrorMessage)
                    .captionFont()
                    .foregroundStyle(.red)
                    .hidden(state.isConfirmPasswordErrorMessageHidden)
            }
            
            Button("Sign Up") {
                state.registerButtonPressed()
            }
            .buttonStyle(
                .filled(
                    backgroundColor: state.isRegisterButtonDisabled ? Color.gray : Color.main
                )
            )
            .headlineFont()
            .disabled(state.isRegisterButtonDisabled)
            .frame(height: 48)
            
            Spacer()
        }
        .padding(16)
        .screenBackground(dismissing: $focusedField)
        .toolBar(
            title: "Register",
            isRightButtonHidden: true,
            leftButtonAction: {
                navigationFlow.pop()
            },
            rightButtonAction: {},
        )
        .onChange(of: state.focusingField) { oldField, newField in
            print("state focusingField change")
            // viewStateのfocusingFieldを更新時にViewのfocusedFieldを更新
            focusedField = newField
            if newField == nil,
               oldField == FocusableField.email {
                state.onEmailTextSubmit(state.emailText)
            }
            
            if newField == nil,
               oldField == FocusableField.password {
                state.onPasswordTextSubmit(state.passwordText)
            }
            
            if newField == nil,
               oldField == FocusableField.confirmPassword {
                state.onConfirmPasswordTextSubmit(state.confirmPasswordText)
            }
        }
        .onChange(of: focusedField) { _, newFocusedField in
            print("focusedField change")
            state.onFocusedFieldChange(newFocusedField)
        }
    }
    }

#Preview {
    @Previewable var state: RegisterScreenState = .init()
    RegisterScreen(state: state)
}

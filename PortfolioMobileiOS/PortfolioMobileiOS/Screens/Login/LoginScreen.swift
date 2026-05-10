import SwiftUI

struct LoginScreen: View {
    
    @State var state: LoginScreenState
    init(state: LoginScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack {
            Text("Mail")
            //TextField(.constant(""), text: .constant(""))
            Text("Password")
        }
        .screenBackground()
    }
}

#Preview {
    @Previewable var state: LoginScreenState = .init()
    LoginScreen(state: state)
}

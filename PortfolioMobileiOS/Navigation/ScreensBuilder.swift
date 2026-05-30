import SwiftUI

@MainActor
struct ScreensBuilder {
    @ViewBuilder
    func pushDestination(for destination: PushDestination) -> some View {
        switch destination {
        case .splash: SplashScreen(state: .init())
        case .login: LoginScreen(state: .init())
        case .register: RegisterScreen(state: .init())
        case .term: TermScreen(state: .init())
        }
    }
}

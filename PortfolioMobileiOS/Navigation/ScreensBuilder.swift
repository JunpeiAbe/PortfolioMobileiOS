import SwiftUI

@MainActor
struct ScreensBuilder {
    private let dependency: AppDependency
    
    init(dependency: AppDependency) {
        self.dependency = dependency
    }
    
    @ViewBuilder
    func rootScreen() -> some View {
        LoginScreen(state: dependency.makeLoginState())
    }
    
    @ViewBuilder
    func pushDestination(for destination: PushDestination) -> some View {
        switch destination {
        case .splash: SplashScreen(state: dependency.makeSplashState())
        case .login: LoginScreen(state: dependency.makeLoginState())
        case .register: RegisterScreen(state: dependency.makeRegisterState())
        case .term: TermScreen(state: dependency.makeTermState())
        case .home: HomeScreen(state: dependency.makeHomeState())
        }
    }
}

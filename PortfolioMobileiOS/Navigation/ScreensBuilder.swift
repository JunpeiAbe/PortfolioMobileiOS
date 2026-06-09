import SwiftUI

@MainActor
struct ScreensBuilder {
    private let dependency: AppDependency
    
    init(dependency: AppDependency) {
        self.dependency = dependency
    }
    
    @ViewBuilder
    func splashScreen() -> some View {
        SplashScreen(state: dependency.makeSplashState())
    }
    @ViewBuilder
    func loginScreen() -> some View {
        LoginScreen(state: dependency.makeLoginState())
    }
    @ViewBuilder
    func registerScreen() -> some View {
        RegisterScreen(state: dependency.makeRegisterState())
    }
    @ViewBuilder
    func termScreen() -> some View {
        TermScreen(state: dependency.makeTermState())
    }
    @ViewBuilder
    func homeRootScreen() -> some View {
        HomeScreen(state: dependency.makeHomeState())
    }
    @ViewBuilder
    func menuRootScreen() -> some View {
        MenuScreen(state: dependency.makeMenuState())
    }
    @ViewBuilder
    func notificationRootScreen() -> some View {
        NotificationScreen(state: dependency.makeNotificationState())
    }
    @ViewBuilder
    func historyRootScreen() -> some View {
        HistoryScreen(state: dependency.makeHistoryState())
    }
    @ViewBuilder
    func settingRootScreen() -> some View {
        SettingScreen(state: dependency.makeSettingState())
    }
    
//    @ViewBuilder
//    func pushDestination(for destination: PushDestination) -> some View {
//        switch destination {
//        case .splash: SplashScreen(state: dependency.makeSplashState())
//        case .login: LoginScreen(state: dependency.makeLoginState())
//        case .register: RegisterScreen(state: dependency.makeRegisterState())
//        case .term: TermScreen(state: dependency.makeTermState())
//        case .main: MainScreen(screenBuilder: .init(dependency: dependency))
//        }
//    }
}

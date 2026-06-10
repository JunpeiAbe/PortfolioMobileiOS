import SwiftUI

struct RootScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var appRouter: AppRouter
    @State private var state: RootScreenState
    private let screenBuilder: ScreensBuilder
    
    init(dependency: AppDependency) {
        self.screenBuilder = ScreensBuilder(dependency: dependency)
        self._appRouter = State(
            initialValue: dependency.appRouter
        )
        self._state = State(
            initialValue: dependency.makeRootState()
        )
    }
    
    var body: some View {
        rootContent
            .loading(
                isPresented: $appRouter.isLoading
            )
            .environment(\.loading, .init(
                show: {
                    appRouter.showLoading()
                },
                hide: {
                    appRouter.hideLoading()
                }
            ))
            .alert(
                appRouter.presentedAlert?.title ?? .init(),
                isPresented: .init(
                    get: { appRouter.presentedAlert != nil },
                    set: { _ in appRouter.presentedAlert = nil }
                ),
                presenting: appRouter.presentedAlert,
                actions: { alert in
                    ForEach(alert.actions) { action in
                        Button(action.title, role: action.role) {
                            appRouter.dismissAlert()
                            action.action()
                        }
                    }
                },
                message: { alert in
                    Text(alert.message)
                }
            )
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }
                guard state.authenticationStore.isLoggedIn else { return }
                Task {
                    await state.checkAppStatus()
                }
            }
            .onChange(of: state.alertContent) { _, newContent in
                if let newContent {
                    appRouter.showAlert(newContent)
                }
            }
    }
    
    @ViewBuilder
    private var rootContent: some View {
        NavigationStack(path: $appRouter.pushDestinations) {
            screenBuilder.splashScreen()
                .navigationDestination(for: PushDestination.self) { destination in
                    switch destination {
                    case .splash:
                        screenBuilder.splashScreen()
                    case .login:
                        screenBuilder.loginScreen()
                    case .register:
                        screenBuilder.registerScreen()
                    case .term:
                        screenBuilder.termScreen()
                    case .main:
                        screenBuilder.mainScreen()
                    }
                }
        }
    }
}

#Preview {
    RootScreen(dependency: AppDependency.debug())
}

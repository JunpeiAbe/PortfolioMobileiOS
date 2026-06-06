import SwiftUI

struct RootScreen: View {
    private let screenBuilder: ScreensBuilder
    @State private var appRouter: AppRouter = .init()
    
    init(dependency: AppDependency) {
        screenBuilder = ScreensBuilder(dependency: dependency)
    }
    
    var body: some View {
        @Bindable var bindableAppRouter = appRouter
        Group {
            switch appRouter.appScene {
            case .splash:
                screenBuilder.splashScreen()
            case .auth:
                NavigationFlowContainer(
                    flow: bindableAppRouter.authNavigationFlow,
                    rootScreen: { screenBuilder.loginScreen() },
                    pushDestination: screenBuilder.pushDestination
                )
            case .main:
                MainScreen(
                    screenBuilder: screenBuilder
                )
            }
        }
        .environment(appRouter)
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
    }
}

#Preview {
    RootScreen(dependency: AppDependency.debug)
}

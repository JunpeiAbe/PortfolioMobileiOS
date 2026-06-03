import Foundation

struct AppDependency {
    var makeSplashState: @MainActor () -> SplashScreenState
    var makeLoginState: @MainActor () -> LoginScreenState
    var makeRegisterState: @MainActor () -> RegisterScreenState
    var makeTermState: @MainActor () -> TermScreenState
    var makeHomeState: @MainActor () -> HomeScreenState
    var makeMenuState: @MainActor () -> MenuScreenState
    var makeHistoryState: @MainActor () -> HistoryScreenState
    var makeNotificationState: @MainActor () -> NotificationScreenState
    var makeSettingState: @MainActor () -> SettingScreenState
    var makeURLSessionClient: @MainActor () -> URLSessionAPIClient
    
    static let debug: Self = .init(
        makeSplashState: {
            SplashScreenState()
        },
        makeLoginState: {
            LoginScreenState()
        },
        makeRegisterState: {
            RegisterScreenState()
        },
        makeTermState: {
            TermScreenState()
        },
        makeHomeState: {
            HomeScreenState()
        },
        makeMenuState: {
            MenuScreenState()
        },
        makeHistoryState: {
            HistoryScreenState()
        },
        makeNotificationState: {
            NotificationScreenState()
        },
        makeSettingState: {
            SettingScreenState()
        },
        makeURLSessionClient: {
            StubResponseConfigurator.configure()
            return URLSessionAPIClient(
                session: .stub,
                configuration: .init(baseURL: URL(string: "https://debug-api.example.com")!)
            )
        }
    )
    
    static let release: Self = .init(
        makeSplashState: {
            SplashScreenState()
        },
        makeLoginState: {
            LoginScreenState()
        },
        makeRegisterState: {
            RegisterScreenState()
        },
        makeTermState: {
            TermScreenState()
        },
        makeHomeState: {
            HomeScreenState()
        },
        makeMenuState: {
            MenuScreenState()
        },
        makeHistoryState: {
            HistoryScreenState()
        },
        makeNotificationState: {
            NotificationScreenState()
        },
        makeSettingState: {
            SettingScreenState()
        },
        makeURLSessionClient: {
            return URLSessionAPIClient(configuration: .init(baseURL: URL(string: "https://release-api.example.com")!))
        }
    )
}

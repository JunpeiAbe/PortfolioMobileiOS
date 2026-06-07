import Foundation

struct AppDependency {
    var makeRootState: @MainActor () -> RootScreenState
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
    var makeKeychainClient: @MainActor () -> DefaultKeychainClient
    
    static let debug: Self = .init(
        makeRootState: {
            RootScreenState(
                dependency: .debug,
                appInfomationStore: DefaultAppInfomationStore(
                    appInfomationRepository: DefaultAppInfomationRepository(
                        apiClient: Self.debug.makeURLSessionClient()
                    )
                ),
                authenticationStore: DefaultAuthenticationStore(
                    authenticationRepository: DefaultAuthenticationRepository(
                        apiClient: Self.debug.makeURLSessionClient(),
                        keychainclient: Self.debug.makeKeychainClient()
                    ),
                    agreeTermRepository: DefaultAgreeTermRepository(
                        apiClient:  Self.debug.makeURLSessionClient()
                    )
                )
            )
        },
        makeSplashState: {
            StubResponseConfigurator.configure()
            return SplashScreenState(
                appInfomationStore: DefaultAppInfomationStore(
                    appInfomationRepository: DefaultAppInfomationRepository(
                        apiClient: Self.debug.makeURLSessionClient()
                    )
                )
            )
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
        },
        makeKeychainClient: {
            return DefaultKeychainClient(service: "debug")
        }
    )
    
    static let release: Self = .init(
        makeRootState: {
            RootScreenState(
                dependency: .release,
                appInfomationStore: DefaultAppInfomationStore(
                    appInfomationRepository: DefaultAppInfomationRepository(
                        apiClient: Self.release.makeURLSessionClient()
                    )
                ),
                authenticationStore: DefaultAuthenticationStore(
                    authenticationRepository: DefaultAuthenticationRepository(
                        apiClient: Self.release.makeURLSessionClient(),
                        keychainclient: Self.release.makeKeychainClient()
                    ),
                    agreeTermRepository: DefaultAgreeTermRepository(
                        apiClient:  Self.release.makeURLSessionClient()
                    )
                )
            )
        },
        makeSplashState: {
            SplashScreenState(appInfomationStore: DefaultAppInfomationStore(
                appInfomationRepository: DefaultAppInfomationRepository(
                    apiClient: Self.release.makeURLSessionClient()
                )
            ))
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
        },
        makeKeychainClient: {
            return DefaultKeychainClient()
        }
    )
}

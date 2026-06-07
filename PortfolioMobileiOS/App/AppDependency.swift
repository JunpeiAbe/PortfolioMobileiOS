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
    @MainActor
    static func debug() -> Self {
        StubResponseConfigurator.configure()
        
        let keychainClient = DefaultKeychainClient(
            service: "debug"
        )
        
        let apiClient = URLSessionAPIClient(
            session: .stub,
            configuration: .init(
                baseURL: URL(string: "https://debug-api.example.com")!
            )
        )
        
        let appInfomationRepository = DefaultAppInfomationRepository(
            apiClient: apiClient
        )
        
        let authenticationRepository = DefaultAuthenticationRepository(
            apiClient: apiClient,
            keychainclient: keychainClient
        )
        
        let agreeTermRepository = DefaultAgreeTermRepository(
            apiClient: apiClient
        )
        
        let appInfomationStore = DefaultAppInfomationStore(
            appInfomationRepository: appInfomationRepository
        )
        
        let authenticationStore = DefaultAuthenticationStore(
            authenticationRepository: authenticationRepository,
            agreeTermRepository: agreeTermRepository
        )
        
        return .init(
            makeRootState: {
                RootScreenState(
                    dependency: .debug(),
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appInfomationStore: appInfomationStore
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
            }
        )
    }
    
    @MainActor
    static func release() -> Self {
        let keychainClient = DefaultKeychainClient()
        
        let apiClient = URLSessionAPIClient(
            configuration: .init(
                baseURL: URL(string: "https://release-api.example.com")!
            )
        )
        
        let appInfomationRepository = DefaultAppInfomationRepository(
            apiClient: apiClient
        )
        
        let authenticationRepository = DefaultAuthenticationRepository(
            apiClient: apiClient,
            keychainclient: keychainClient
        )
        
        let agreeTermRepository = DefaultAgreeTermRepository(
            apiClient: apiClient
        )
        
        let appInfomationStore = DefaultAppInfomationStore(
            appInfomationRepository: appInfomationRepository
        )
        
        let authenticationStore = DefaultAuthenticationStore(
            authenticationRepository: authenticationRepository,
            agreeTermRepository: agreeTermRepository
        )
        
        return .init(
            makeRootState: {
                RootScreenState(
                    dependency: .release(),
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appInfomationStore: appInfomationStore
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
            }
        )
    }
}

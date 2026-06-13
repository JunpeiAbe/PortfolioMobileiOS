import Foundation

struct AppDependency {
    let appRouter: AppRouter
    var makeRootState: @MainActor () -> RootScreenState
    var makeSplashState: @MainActor () -> SplashScreenState
    var makeLoginState: @MainActor () -> LoginScreenState
    var makeRegisterState: @MainActor () -> RegisterScreenState
    var makeTermState: @MainActor () -> TermScreenState
    var makeMainState: @MainActor () -> MainScreenState
    var makeHomeState: @MainActor () -> HomeScreenState
    var makeMenuState: @MainActor () -> MenuScreenState
    var makeHistoryState: @MainActor () -> HistoryScreenState
    var makeNotificationState: @MainActor () -> NotificationScreenState
    var makeSettingState: @MainActor () -> SettingScreenState
    @MainActor
    static func debug() -> Self {
        StubResponseConfigurator.configure()
        let appRouter = DefaultAppRouter()
        let userDefaultsClient = DefaultUserDefaultsClient()
        
        let keychainClient = DefaultKeychainClient(
            service: "debug"
        )
        
        let accessTokenProvider = AccessTokenProvider(keychainClient: keychainClient)
        
        let apiClient = URLSessionAPIClient(
            session: .stub,
            configuration: .init(
                baseURL: URL(string: "https://debug-api.example.com")!
            ),
            accessTokenProvider: accessTokenProvider
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
        
        let noticeRepository = DefaultNoticeRepository(
            apiClient: apiClient
        )
        
        let appInfomationStore = DefaultAppInfomationStore(
            appInfomationRepository: appInfomationRepository
        )
        
        let authenticationStore = DefaultAuthenticationStore(
            authenticationRepository: authenticationRepository,
            agreeTermRepository: agreeTermRepository,
            userDefaultClient: userDefaultsClient,
            keychainClient: keychainClient
        )
        
        let noticeStore = DefaultNoticeStore(
            noticeRepository: noticeRepository
        )
        
        return .init(
            appRouter: appRouter,
            makeRootState: {
                RootScreenState(
                    dependency: .debug(),
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: appRouter,
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: appRouter,
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeMainState: {
                MainScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
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
                NotificationScreenState(
                    appRouter: appRouter,
                    noticeStore: noticeStore
                )
            },
            makeSettingState: {
                SettingScreenState()
            }
        )
    }
    
    @MainActor
    static func release() -> Self {
        let appRouter = DefaultAppRouter()
        let userDefaultsClient = DefaultUserDefaultsClient()
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
        
        let noticeRepository = DefaultNoticeRepository(
            apiClient: apiClient
        )
        
        let appInfomationStore = DefaultAppInfomationStore(
            appInfomationRepository: appInfomationRepository
        )
        
        let authenticationStore = DefaultAuthenticationStore(
            authenticationRepository: authenticationRepository,
            agreeTermRepository: agreeTermRepository,
            userDefaultClient: userDefaultsClient,
            keychainClient: keychainClient
        )
        
        let noticeStore = DefaultNoticeStore(
            noticeRepository: noticeRepository
        )
        
        return .init(
            appRouter: appRouter,
            makeRootState: {
                RootScreenState(
                    dependency: .release(),
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: appRouter,
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: appRouter,
                    appInfomationStore: appInfomationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeMainState: {
                MainScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
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
                NotificationScreenState(
                    appRouter: appRouter,
                    noticeStore: noticeStore
                )
            },
            makeSettingState: {
                SettingScreenState()
            }
        )
    }
}

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
    var makeFeaturesState: @MainActor () -> FeaturesScreenState
    var makeFeatureDetailState: @MainActor (Feature) -> FeatureDetailScreenState
    
    @MainActor
    static func debug(
        appRouter: AppRouter = DefaultAppRouter(),
        userDefaultsClient: UserDefaultsClient = DefaultUserDefaultsClient(),
        keychainClient: KeychainClient = DefaultKeychainClient(service: "debug"),
        apiClient: URLSessionAPIClient? = nil,
        appInfomationRepository: AppInfomationRepository? = nil,
        authenticationRepository: AuthenticationRepository? = nil,
        agreeTermRepository: AgreeTermRepository? = nil,
        noticeRepository: NoticeRepository? = nil
    ) -> Self {
        
        StubResponseConfigurator.configure()
        
        let accessTokenProvider = AccessTokenProvider(keychainClient: keychainClient)
        
        let debugApiClient = apiClient ?? URLSessionAPIClient(
            session: .stub,
            configuration: .init(
                baseURL: Bundle.main.apiBaseURL
            ),
            accessTokenProvider: accessTokenProvider
        )
        
        let debugAppInfomationRepository = appInfomationRepository ?? DefaultAppInfomationRepository(
            apiClient: debugApiClient
        )
        
        let debugAuthenticationRepository = DefaultAuthenticationRepository(
            apiClient: debugApiClient,
            keychainclient: keychainClient
        )
        
        let debugAgreeTermRepository = DefaultAgreeTermRepository(
            apiClient: debugApiClient
        )
        
        let debugNoticeRepository = DefaultNoticeRepository(
            apiClient: debugApiClient
        )
        
        let debugFeaturesRepository = DefaultFeaturesRepository(
            apiClient: debugApiClient
        )
        
        let debugAppInfomationStore = DefaultAppInfomationStore(
            appInfomationRepository: debugAppInfomationRepository
        )
        
        let debugAuthenticationStore = DefaultAuthenticationStore(
            authenticationRepository: debugAuthenticationRepository,
            agreeTermRepository: debugAgreeTermRepository,
            userDefaultClient: userDefaultsClient,
            keychainClient: keychainClient
        )
        
        let debugNoticeStore = DefaultNoticeStore(
            noticeRepository: debugNoticeRepository
        )
        
        let debugFeaturesStore = DefaultFeaturesStore(
            featuresRepository: debugFeaturesRepository
        )
        
        return .init(
            appRouter: appRouter,
            makeRootState: {
                RootScreenState(
                    appInfomationStore: debugAppInfomationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: appRouter,
                    appInfomationStore: debugAppInfomationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: appRouter,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: appRouter,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: appRouter,
                    appInfomationStore: debugAppInfomationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeMainState: {
                MainScreenState(
                    appRouter: appRouter,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeHomeState: {
                HomeScreenState(
                    appRouter: appRouter,
                    authenticationStore: debugAuthenticationStore
                )
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
                    noticeStore: debugNoticeStore
                )
            },
            makeSettingState: {
                SettingScreenState()
            },
            makeFeaturesState: {
                FeaturesScreenState(
                    appRouter: appRouter,
                    featuresStore: debugFeaturesStore
                )
            },
            makeFeatureDetailState: { feature in
                debugFeaturesStore.selectedFeature = feature
                return FeatureDetailScreenState(
                    appRouter: appRouter,
                    featuresStore: debugFeaturesStore
                )
            }
        )
    }
    
    @MainActor
    static func staging(
        keychainClient: KeychainClient = DefaultKeychainClient(service: "staging"),
        apiClient: URLSessionAPIClient? = nil,
    ) -> Self {
        let appRouter = DefaultAppRouter()
        let userDefaultsClient = DefaultUserDefaultsClient()
        let accessTokenProvider = AccessTokenProvider(keychainClient: keychainClient)
        let apiClient = URLSessionAPIClient(
            configuration: .init(
                baseURL: Bundle.main.apiBaseURL
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
        
        let featuresRepository = DefaultFeaturesRepository(
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
        
        let featuresStore = DefaultFeaturesStore(
            featuresRepository: featuresRepository
        )
        
        return .init(
            appRouter: appRouter,
            makeRootState: {
                RootScreenState(
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
                HomeScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
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
            },
            makeFeaturesState: {
                FeaturesScreenState(
                    appRouter: appRouter,
                    featuresStore: featuresStore
                )
            },
            makeFeatureDetailState: { feature in
                featuresStore.selectedFeature = feature
                return FeatureDetailScreenState(
                    appRouter: appRouter,
                    featuresStore: featuresStore
                )
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
                baseURL: Bundle.main.apiBaseURL
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
        
        let featuresRepository = DefaultFeaturesRepository(
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
        
        let featuresStore = DefaultFeaturesStore(
            featuresRepository: featuresRepository
        )
        
        return .init(
            appRouter: appRouter,
            makeRootState: {
                RootScreenState(
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
                HomeScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore
                )
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
            },
            makeFeaturesState: {
                FeaturesScreenState(
                    appRouter: appRouter,
                    featuresStore: featuresStore
                )
            },
            makeFeatureDetailState: { feature in
                featuresStore.selectedFeature = feature
                return FeatureDetailScreenState(
                    appRouter: appRouter,
                    featuresStore: featuresStore
                )
            }
        )
    }
}

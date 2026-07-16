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
        pushNotificationClient: PushNotificationClient = DefaultPushNotificationClient(),
        apiClient: URLSessionAPIClient? = nil,
        appInformationRepository: AppInformationRepository? = nil,
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
        
        let debugPushNotificationRepository = DefaultPushNotificationRepository(
            pushNotificationClient: pushNotificationClient,
            apiClient: debugApiClient
        )
        
        let debugAppInformationRepository = appInformationRepository ?? DefaultAppInformationRepository(
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
        
        let debugPushNotificationStore = DefaultPushNotificationStore(
            pushNotificationRepository: debugPushNotificationRepository
        )
        
        let debugAppInformationStore = DefaultAppInformationStore(
            appInformationRepository: debugAppInformationRepository
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
                    appInformationStore: debugAppInformationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: appRouter,
                    pushNotificationStore: debugPushNotificationStore,
                    appInformationStore: debugAppInformationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: appRouter,
                    authenticationStore: debugAuthenticationStore,
                    pushNotificationStore: debugPushNotificationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: appRouter,
                    authenticationStore: debugAuthenticationStore,
                    pushNotificationStore: debugPushNotificationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: appRouter,
                    appInformationStore: debugAppInformationStore,
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
        pushNotificationClient: PushNotificationClient = DefaultPushNotificationClient(),
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
        
        let pushNotificationRepository = DefaultPushNotificationRepository(
            pushNotificationClient: pushNotificationClient,
            apiClient: apiClient
        )
        
        let appInformationRepository = DefaultAppInformationRepository(
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
        
        let pushNotificationStore = DefaultPushNotificationStore(
            pushNotificationRepository: pushNotificationRepository
        )
        
        let appInformationStore = DefaultAppInformationStore(
            appInformationRepository: appInformationRepository
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
                    appInformationStore: appInformationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: appRouter,
                    pushNotificationStore: pushNotificationStore,
                    appInformationStore: appInformationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore,
                    pushNotificationStore: pushNotificationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore,
                    pushNotificationStore: pushNotificationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: appRouter,
                    appInformationStore: appInformationStore,
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
        let pushNotificationClient = DefaultPushNotificationClient()
        
        let apiClient = URLSessionAPIClient(
            configuration: .init(
                baseURL: Bundle.main.apiBaseURL
            ),
            accessTokenProvider: AccessTokenProvider(keychainClient: keychainClient)
        )
        
        let pushNotificationRepository = DefaultPushNotificationRepository(
            pushNotificationClient: pushNotificationClient,
            apiClient: apiClient
        )
        
        let appInformationRepository = DefaultAppInformationRepository(
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
        
        let pushNotificationStore = DefaultPushNotificationStore(
            pushNotificationRepository: pushNotificationRepository
        )
        
        let appInformationStore = DefaultAppInformationStore(
            appInformationRepository: appInformationRepository
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
                    appInformationStore: appInformationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: appRouter,
                    pushNotificationStore: pushNotificationStore,
                    appInformationStore: appInformationStore,
                    authenticationStore: authenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore,
                    pushNotificationStore: pushNotificationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: appRouter,
                    authenticationStore: authenticationStore,
                    pushNotificationStore: pushNotificationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: appRouter,
                    appInformationStore: appInformationStore,
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

import Foundation

extension AppDependency {
    static func debug(
        appRouter: AppRouter? = nil,
        userDefaultsClient: UserDefaultsClient? = nil,
        keychainClient: KeychainClient? = nil,
        pushNotificationClient: PushNotificationClient? = nil,
        apiClient: URLSessionAPIClient? = nil,
        appInformationRepository: AppInformationRepository? = nil,
        authenticationRepository: AuthenticationRepository? = nil,
        agreeTermRepository: AgreeTermRepository? = nil,
        noticeRepository: NoticeRepository? = nil
    ) -> Self {
        
        StubResponseConfigurator.configure()
        let debugUserDefaultsClient = userDefaultsClient ?? DefaultUserDefaultsClient()
        let debugKeyChainClient = keychainClient ?? DefaultKeychainClient(service: "debug")
        let accessTokenProvider = AccessTokenProvider(keychainClient: debugKeyChainClient)
        let debugPushNotificationClient = pushNotificationClient ?? StubPushNotificationClient()
        
        let debugAppRouter = appRouter ?? DefaultAppRouter()
        
        let debugApiClient = apiClient ?? URLSessionAPIClient(
            session: .stub,
            configuration: .init(
                baseURL: Bundle.main.apiBaseURL
            ),
            accessTokenProvider: accessTokenProvider
        )
        
        let debugPushNotificationRepository = DefaultPushNotificationRepository(
            pushNotificationClient: debugPushNotificationClient,
            apiClient: debugApiClient
        )
        
        let debugAppInformationRepository = appInformationRepository ?? DefaultAppInformationRepository(
            apiClient: debugApiClient
        )
        
        let debugAuthenticationRepository = DefaultAuthenticationRepository(
            apiClient: debugApiClient,
            keychainclient: debugKeyChainClient
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
            userDefaultClient: debugUserDefaultsClient,
            keychainClient: debugKeyChainClient
        )
        
        let debugNoticeStore = DefaultNoticeStore(
            noticeRepository: debugNoticeRepository
        )
        
        let debugFeaturesStore = DefaultFeaturesStore(
            featuresRepository: debugFeaturesRepository
        )
        
        return .init(
            appRouter: DefaultAppRouter(),
            makeRootState: {
                RootScreenState(
                    appInformationStore: debugAppInformationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeSplashState: {
                SplashScreenState(
                    appRouter: debugAppRouter,
                    pushNotificationStore: debugPushNotificationStore,
                    appInformationStore: debugAppInformationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeLoginState: {
                LoginScreenState(
                    appRouter: debugAppRouter,
                    authenticationStore: debugAuthenticationStore,
                    pushNotificationStore: debugPushNotificationStore
                )
            },
            makeRegisterState: {
                RegisterScreenState(
                    appRouter: debugAppRouter,
                    authenticationStore: debugAuthenticationStore,
                    pushNotificationStore: debugPushNotificationStore
                )
            },
            makeTermState: {
                TermScreenState(
                    appRouter: debugAppRouter,
                    appInformationStore: debugAppInformationStore,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeMainState: {
                MainScreenState(
                    appRouter: debugAppRouter,
                    authenticationStore: debugAuthenticationStore
                )
            },
            makeHomeState: {
                HomeScreenState(
                    appRouter: debugAppRouter,
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
                    appRouter: debugAppRouter,
                    noticeStore: debugNoticeStore
                )
            },
            makeSettingState: {
                SettingScreenState()
            },
            makeFeaturesState: {
                FeaturesScreenState(
                    appRouter: debugAppRouter,
                    featuresStore: debugFeaturesStore
                )
            },
            makeFeatureDetailState: { feature in
                debugFeaturesStore.selectedFeature = feature
                return FeatureDetailScreenState(
                    appRouter: debugAppRouter,
                    featuresStore: debugFeaturesStore
                )
            }
        )
    }
}

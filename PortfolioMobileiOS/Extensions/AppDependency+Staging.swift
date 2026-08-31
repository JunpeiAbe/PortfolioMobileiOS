import Foundation

extension AppDependency {
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
}


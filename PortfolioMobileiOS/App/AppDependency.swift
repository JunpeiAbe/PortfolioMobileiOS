import Foundation

struct AppDependency {
    let appRouter: AppRouter
    var makeRootState: () -> RootScreenState
    var makeSplashState: () -> SplashScreenState
    var makeLoginState: () -> LoginScreenState
    var makeRegisterState: () -> RegisterScreenState
    var makeTermState: () -> TermScreenState
    var makeMainState: () -> MainScreenState
    var makeHomeState: () -> HomeScreenState
    var makeMenuState: () -> MenuScreenState
    var makeHistoryState: () -> HistoryScreenState
    var makeNotificationState: () -> NotificationScreenState
    var makeSettingState: () -> SettingScreenState
    var makeFeaturesState: () -> FeaturesScreenState
    var makeFeatureDetailState: (Feature) -> FeatureDetailScreenState
}

import Foundation

@MainActor
@Observable
final class HomeScreenState {
    var loadingState: LoadingState = .idle
    var appRouter: AppRouter
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    
    init(
        appRouter: AppRouter,
        authenticationStore: AuthenticationStore
    ) {
        self.appRouter = appRouter
        self.authenticationStore = authenticationStore
    }
}

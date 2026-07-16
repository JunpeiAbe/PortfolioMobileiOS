import Foundation

@MainActor
@Observable
final class MainScreenState {
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
    
    func logoutButtonPressed() {
        Task {
            do {
                try await authenticationStore.logout()
                appRouter.pop(.login)
            } catch let error as APIClientError {
            } catch {
            }
        }
    }
}

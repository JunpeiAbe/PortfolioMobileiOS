import Foundation

@MainActor
@Observable
final class TermScreenState {
    
    var isChecked: Bool = false
    var loadingState: LoadingState = .idle
    var isAgreeButtonDisabled: Bool {
        !isChecked
        || loadingState == .loading
    }
    let appRouter: AppRouter
    
    init(
        appRouter: AppRouter
    ) {
        self.appRouter = appRouter
    }
    
    func checkButtonPressed() {
        isChecked.toggle()
    }
    
    func agreeButtonPressed() {
        appRouter.push(.main)
    }
}

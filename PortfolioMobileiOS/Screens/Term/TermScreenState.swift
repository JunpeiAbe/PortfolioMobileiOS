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
    
    func checkButtonPressed() {
        isChecked.toggle()
    }
    
    func agreeButtonPressed(completion: @escaping () -> Void) {
        completion()
    }
}

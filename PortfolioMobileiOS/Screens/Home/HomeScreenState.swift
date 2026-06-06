import Foundation

@MainActor
@Observable
final class HomeScreenState {
    var loadingState: LoadingState = .idle
}

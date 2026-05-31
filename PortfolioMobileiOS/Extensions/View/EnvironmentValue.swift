import SwiftUI

extension EnvironmentValues {
    /// ローディング表示
    var loading: LoadingActions {
        get { self[LoadingActionsKey.self] }
        set { self[LoadingActionsKey.self] = newValue }
    }
    
    struct LoadingActionsKey: EnvironmentKey {
        static let defaultValue = LoadingActions(show: {}, hide: {})
    }
    
    struct LoadingActions {
        let show: @MainActor () -> Void
        let hide: @MainActor () -> Void
    }
}

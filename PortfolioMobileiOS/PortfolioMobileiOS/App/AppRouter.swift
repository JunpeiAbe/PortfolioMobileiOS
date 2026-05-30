import SwiftUI

@MainActor
@Observable
final class AppRouter {
    /// NavigationFlowを定義、タブの場合はメインのFlowから子のFlowを分岐させる
    var mainNavigationFlow: NavigationFlow
    
    init() {
        self.mainNavigationFlow = NavigationFlow()
    }
}

import SwiftUI

@MainActor
@Observable
final class AppRouter {
    /// NavigationFlowを定義、タブの場合はメインのFlowから子のFlowを分岐させる
    var mainNavigationFlow: NavigationFlow
    var homeNavigationFlow: NavigationFlow
    var menuNavigationFlow: NavigationFlow
    var historyNavigationFlow: NavigationFlow
    var notificationsNavigationFlow: NavigationFlow
    var settignsNavigationFlow: NavigationFlow
    /// 選択状態のタブ
    var selectedTab: SelectableTab = .home
    init() {
        mainNavigationFlow = NavigationFlow()
        homeNavigationFlow = NavigationFlow()
        menuNavigationFlow = NavigationFlow()
        historyNavigationFlow = NavigationFlow()
        notificationsNavigationFlow = NavigationFlow()
        settignsNavigationFlow = NavigationFlow()
    }
}

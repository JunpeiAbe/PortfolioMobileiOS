import SwiftUI

@MainActor
@Observable
final class AppRouter {
    /// 現在表示するアプリ全体のシーン
    var appScene: AppScene = .splash
    /// NavigationFlowを定義、タブの場合はメインのFlowから子のFlowを分岐させる
    /// アプリ全体用の親Flow
    var rootNavigationFlow: NavigationFlow
    /// 認証画面用Flow
    var authNavigationFlow: NavigationFlow
    /// メインタブ用
    var homeNavigationFlow: NavigationFlow
    var menuNavigationFlow: NavigationFlow
    var historyNavigationFlow: NavigationFlow
    var notificationsNavigationFlow: NavigationFlow
    var settingsNavigationFlow: NavigationFlow
    /// 選択状態のタブ
    var selectedTab: SelectableTab = .home
    var isLoading: Bool = false
    /// 表示済の標準アラート
    var presentedAlert: PresentAlert?
    /// 複数アラート表示用のキュー
    var alertQueue: [PresentAlert] = []
    
    init() {
        let rootFlow = NavigationFlow()
        rootNavigationFlow = rootFlow
        authNavigationFlow = NavigationFlow(parentFlow: rootFlow)
        homeNavigationFlow = NavigationFlow(parentFlow: rootFlow)
        menuNavigationFlow = NavigationFlow(parentFlow: rootFlow)
        historyNavigationFlow = NavigationFlow(parentFlow: rootFlow)
        notificationsNavigationFlow = NavigationFlow(parentFlow: rootFlow)
        settingsNavigationFlow = NavigationFlow(parentFlow: rootFlow)
    }
    
    func showLoading() {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
    
    func showSplash() {
        appScene = .splash
    }
    
    func showAuth() {
        appScene = .auth
    }
    
    func showMain() {
        selectedTab = .home
        appScene = .main
    }
    
    func logout() {
        appScene = .auth
    }
    /// 標準アラートの表示
    func showAlert(_ alert: PresentAlert) {
        switch alert.policy {
            
        case .enqueue:
            if presentedAlert == nil {
                presentedAlert = alert
            } else {
                alertQueue.append(alert)
            }
        case .dropIfPresenting:
            // すでに表示済みの場合は表示しない
            guard presentedAlert == nil else { return }
            presentedAlert = alert
        case .replaceCurrent:
            // すでに表示済かどうかに関わらず置き換え
            presentedAlert = alert
        }
        print("presentedAlert:\(String(describing: presentedAlert))")
    }
    /// 標準アラートの非表示
    func dismissAlert() {
        presentedAlert = nil
        /// 追加表示がある場合
        if !alertQueue.isEmpty {
            let nextAlert = alertQueue.removeFirst()
            // 前のアラートの非表示後に表示されないため遅延処理を追加
            Task { @MainActor in
                try await Task.sleep(for: .milliseconds(300))
                presentedAlert = nextAlert
            }
        }
    }
    /// 標準アラートを全て非表示
    func dismissAllAlerts() {
        presentedAlert = nil
        alertQueue.removeAll()
    }
}

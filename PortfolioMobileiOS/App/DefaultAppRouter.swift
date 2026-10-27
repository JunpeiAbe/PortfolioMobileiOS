import SwiftUI

@MainActor
@Observable
final class DefaultAppRouter: AppRouter {
    /// 選択状態のタブ
    var selectedTab: SelectableTab = .home
    var isLoading: Bool = false
    /// 画面履歴
    var pushDestinations: [PushDestination] = []
    /// 表示済の標準アラート
    var presentedAlert: PresentAlert?
    /// 複数アラート表示用のキュー
    var alertQueue: [PresentAlert] = []
    
    init() {}
    
    /// 一画面先に遷移
    func push(_ destination: PushDestination) {
        pushDestinations.append(destination)
    }
    /// 一画面前に戻る
    func pop() {
        if !pushDestinations.isEmpty {
            pushDestinations.removeLast()
        }
    }
    /// 指定画面に戻る
    func pop(_ destination: PushDestination) {
        while let last = pushDestinations.last,
              last != destination {
            pushDestinations.removeLast()
        }
    }
    /// ルート画面に戻る
    func popToRoot() {
        pushDestinations = []
    }
    
    func showLoading() {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
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
    }
    /// 標準アラートの非表示
    func dismissAlert() {
        presentedAlert = nil
        /// 追加表示がある場合
        if !alertQueue.isEmpty {
            let nextAlert = alertQueue.removeFirst()
            // 前のアラートの非表示後に表示されないため遅延処理を追加
            Task {
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

import SwiftUI

@MainActor
protocol AppRouter {
    /// 選択状態のタブ
    var selectedTab: SelectableTab { get set }
    var isLoading: Bool { get set }
    /// 画面履歴
    var pushDestinations: [PushDestination] { get set }
    /// 表示済の標準アラート
    var presentedAlert: PresentAlert? { get set }
    /// 複数アラート表示用のキュー
    var alertQueue: [PresentAlert] { get set }
    /// 一画面先に遷移
    func push(_ destination: PushDestination)
    /// 一画面前に戻る
    func pop()
    /// 指定画面に戻る
    func pop(_ destination: PushDestination)
    /// ルート画面に戻る
    func popToRoot()
    func showLoading()
    func hideLoading()
    /// 標準アラートの表示
    func showAlert(_ alert: PresentAlert)
    /// 標準アラートの非表示
    func dismissAlert()
    /// 標準アラートを全て非表示
    func dismissAllAlerts()
}

import Foundation
import SwiftUI
/// 選択可能なタブ定義
enum SelectableTab: Hashable, CaseIterable {
    /// ホーム
    case home
    /// メニュー
    case menu
    /// 通知
    case notification
    /// 履歴
    case history
    /// 設定
    case setting
    
    var title: String {
        switch self {
            
        case .home:
            "home"
        case .menu:
            "menu"
        case .notification:
            "notification"
        case .history:
            "history"
        case .setting:
            "setting"
        }
    }
}

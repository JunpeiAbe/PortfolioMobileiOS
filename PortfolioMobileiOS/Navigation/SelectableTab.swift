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
            "Home"
        case .menu:
            "Menu"
        case .notification:
            "Notification"
        case .history:
            "History"
        case .setting:
            "Setting"
        }
    }
}

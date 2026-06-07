import SwiftUI
/// 表示可能な標準アラート
struct PresentAlert: Equatable {
    let title: String
    let message: String
    let actions: [PresentAlertAction]
    let policy: AlertPresentationPolicy
    
    init(
        title: String,
        message: String,
        actions: [PresentAlertAction] = [],
        policy: AlertPresentationPolicy = .enqueue
    ) {
        self.title = title
        self.message = message
        self.actions = actions
        self.policy = policy
    }
}

/// 標準アラートに表示するボタン
struct PresentAlertAction: Identifiable, Equatable {
    static func == (lhs: PresentAlertAction, rhs: PresentAlertAction) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.role == rhs.role
    }
    
    let id = UUID()
    let title: String
    let role: ButtonRole?
    let action: @MainActor () -> Void
    init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping @MainActor () -> Void = {}
    ) {
        self.title = title
        self.role = role
        self.action = action
    }
}

extension PresentAlertAction {
    static let ok = PresentAlertAction(
        title: "OK"
    )
    static let cancel = PresentAlertAction(
        title: "キャンセル",
        role: .cancel
    )
}

enum AlertPresentationPolicy: Equatable {
    /// 順番に表示
    case enqueue
    /// 表示中なら無視
    case dropIfPresenting
    /// 後勝ちで置き換え
    case replaceCurrent
}

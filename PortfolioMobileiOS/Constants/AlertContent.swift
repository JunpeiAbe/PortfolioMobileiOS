import Foundation

enum AlertContent: Equatable {
    static let sample: PresentAlert = .init(
        title: "タイトル",
        message: "メッセージ",
        actions: [
            .cancel,
            .ok
        ]
    )
    /// 強制アップデート
    static func forceUpdate(action: @escaping @MainActor () -> Void) -> PresentAlert {
        .init(
            title: "最新版へのアップデートが必要です",
            message: "現在のバージョンではご利用いただけません。最新版にアップデートしてください。",
            actions: [
                .init(
                    title: "アップデート",
                    action: action
                )
            ],
            policy: .replaceCurrent
        )
    }
    /// メンテナンス
    static let maintenance: PresentAlert = .init(
        title: "メンテナンス中です",
        message: "現在、サービスをご利用できません。しばらく時間を置いてから再度お試しください。",
        actions: [.ok],
        policy: .replaceCurrent
    )
}


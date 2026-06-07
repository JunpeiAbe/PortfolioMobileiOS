import SwiftUI
/// 画面描画時に一度だけ処理を実行するモディファイア(Task版)
struct TaskOnceModifier: ViewModifier {
    // 処理を実行するアクション
    let action: @Sendable () async -> Void
    // 実行済みフラグを保持するための状態変数
    @State private var hasExecuted = false
    
    func body(content: Content) -> some View {
        content
            .task {
                // まだ実行されていなければアクションを実行
                if !hasExecuted {
                    await action()
                    hasExecuted = true
                }
            }
    }
}

extension View {
    /// 画面描画時に一度だけ非同期処理を実行するモディファイア
    /// - Parameter perform: 実行する非同期処理
    /// - Returns: モディファイアが適用されたビュー
    func taskOnce(perform action: @escaping @Sendable () async -> Void) -> some View {
        modifier(TaskOnceModifier(action: action))
    }
}

import SwiftUI
/// 画面描画時に一度だけ処理を実行するモディファイア
struct OnAppearOnceModifier: ViewModifier {
    // 処理を実行するアクション
    let action: () -> Void
    // 実行済みフラグを保持するための状態変数
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // まだ実行されていなければアクションを実行
                if !hasAppeared {
                    action()
                    hasAppeared = true
                }
            }
    }
}

extension View {
    /// 画面描画時に一度だけ処理を実行するモディファイア
    /// - Parameter perform: 実行する処理
    /// - Returns: モディファイアが適用されたビュー
    func onAppearOnce(perform action: @escaping () -> Void) -> some View {
        modifier(OnAppearOnceModifier(action: action))
    }
}

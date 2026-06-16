import Foundation
/// Push遷移可能な画面定義
enum PushDestination: Hashable {
    /// スプラッシュ画面
    case splash
    /// ログイン画面
    case login
    /// ユーザー登録画面
    case register
    /// 利用規約同意画面
    case term
    /// メイン
    case main
    /// 機能詳細
    case featureDetail(_ feature: Feature)
}

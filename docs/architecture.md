# アーキテクチャ

このプロジェクトではSVVSを採用しています。SwiftUIの画面表示と状態管理を分けつつ、複数画面で共有する状態やユースケースをStoreに集約する構成です。

## SVVSの役割

- `Screen`: 画面単位のSwiftUI Viewです。表示とユーザー操作の受け渡しに集中します。
- `ViewState`: 画面ごとの状態管理と画面イベントの処理を担当します。本プロジェクトでは `*ScreenState` として実装しています。
- `Store`: 認証状態、お知らせ一覧、機能一覧など、複数画面で利用する状態とユースケースを集約します。
- `Service / Repository`: API通信、Keychain、UserDefaults、Firebase Messagingなど、外部データや永続化に関わる処理を担当します。

## 採用理由

Viewに通信処理や永続化処理を直接持たせず、画面状態、アプリ状態、データ取得の責務を分離するためです。  
画面ごとの状態は `*ScreenState` に閉じ、複数画面で共有する処理は `Store` に寄せることで、画面追加やAPI差し替えがしやすい構成にしています。

## 依存関係

依存関係は `AppDependency` で組み立てています。Debug / Staging / ReleaseごとにAPI Client、Repository、Storeを差し替えられるため、開発時はスタブレスポンスで画面確認し、本番では実通信へ切り替えられます。

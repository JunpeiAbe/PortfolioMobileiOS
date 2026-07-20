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

## 設計判断

### SwiftUI Viewと画面ロジックの分離

SwiftUI Viewには画面描画を担当させ、入力値の検証、非同期処理、画面遷移などのロジックは`ScreenState`へ分離しています。

Viewへロジックが集中すると、表示状態と処理の関係が追いにくくなり、画面操作を伴わないUnit Testも難しくなります。そこで、画面ごとに`*ScreenState`を用意し、状態とイベント処理を一か所へ集約しました。

これにより、Viewを起動せずに入力検証、API成功・失敗時の状態変化、画面遷移などをSwift Testingで検証できます。

### ScreenStateとStoreの責務分担

`ScreenState`は画面固有の状態とユーザー操作を管理し、`Store`は複数画面で共有される状態とユースケースを管理します。

例えば、入力中のメールアドレスやフォーカス状態は`LoginScreenState`が持ち、Access Tokenやログイン状態は`AuthenticationStore`が管理します。この境界により、画面内だけで完結する一時的な状態と、画面をまたいで利用する状態を分離しています。

### Repositoryによるデータ取得処理の抽象化

API通信やデータ保存の詳細を画面やStoreから隠すため、Repository ProtocolをDomain層に定義し、Data層で実装しています。

StoreはURLSessionやレスポンス形式を直接意識せず、必要なデータ操作だけをRepositoryへ依頼します。通信方式や保存先を変更した場合も、画面やStoreへの影響を限定できる構成です。

Unit TestではRepositoryをSpyへ差し替え、実際の通信を行わずに成功・失敗や呼び出し内容を検証しています。

### AppDependencyによる依存性注入

依存オブジェクトの生成と組み立ては`AppDependency`へ集約しています。

画面やStoreの内部で具体的なRepositoryを直接生成すると、実装への依存が強くなり、テスト時の差し替えが難しくなります。必要な依存関係を外部から注入することで、本番用の実装、Debug用のStub、Unit Test用のSpyを利用目的に応じて切り替えられるようにしています。

### 実行環境の分離

Debug、Staging、Releaseごとに設定を分離し、APIの接続先やStub Responseの利用方法を切り替えています。

Debug環境ではバックエンドAPIが利用できない状態でも、ローカルのStub Responseを使って主要画面と画面遷移を確認できます。本番向けの処理へデバッグ専用の条件分岐が広がらないよう、環境ごとの差異は依存関係の生成部分へ寄せています。

### Swift Concurrencyの採用

API通信やStoreの非同期処理には`async/await`を使用しています。コールバック形式と比較して、成功・失敗を含む処理の流れを直線的に記述でき、画面のLoading状態も開始から終了まで追いやすくなります。

画面状態を更新する処理は`MainActor`上で実行し、UIに関係する状態変更の実行コンテキストを明確にしています。

### Unit Testの方針

Unit TestにはSwift Testingを採用し、Validation、API Client、永続化、Repository、Store、画面状態、Navigationを対象にしています。

入力値の長さやHTTPステータスなど、同じ観点で複数の値を検証するテストはParameterized Testへまとめています。また、各テストには検証目的が分かるコメントを記載しています。

依存先への呼び出し内容を確認するTest DoubleにはSpyと命名し、戻り値の設定だけでなく、引数や呼び出し回数を記録して検証しています。具体的なテスト対象とケースは[Unit Testケース一覧](unit-test-cases.md)にまとめています。

### GitHub Actionsによる品質確認

ローカル環境だけに依存せずUnit Testを継続的に実行するため、GitHub Actionsを導入しています。

`master`へのpushとPull Requestの作成・更新時にUnit Testを実行し、変更による既存機能への影響を早期に検出します。同じブランチで新しい変更がpushされた場合は古い実行をキャンセルし、不要なCI実行を抑える構成です。

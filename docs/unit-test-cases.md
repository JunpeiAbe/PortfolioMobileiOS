# Unit Test Cases

本ドキュメントは、`PortfolioMobileiOSTests`で実装しているSwift Testingのテストケース一覧です。
入力値の境界や同種の状態はParameterized Testにまとめています。

## Validation

### MailAddressValidator

- 最小構成の正常なメールアドレス
- 一般的なメールアドレス
- 空文字
- `@`なし
- Local partなし
- Domainなし
- Domain先頭の`.`
- Domain内で連続する`.`

### PasswordValidator

- 8文字の正常値
- 32文字の正常値
- 8文字未満
- 数字なし
- 英字なし
- 記号なし
- 許可されていない記号
- 全角文字

## Value objects / Extensions

### AppVersion

- major、minor、patchの大小比較
- `1.9.0`と`1.10.0`の比較
- バージョン要素数が異なる値の比較
- 同一バージョン
- 省略された末尾の`0`を含む等価性

### LoadingState

- idle、loading、loaded、failedの`isLoading`

### String

- ISO 8601 UTCからJSTへの変換
- 不正な日付文字列では元の文字列を返す

### SelectableTab

- 全タブの表示タイトル

## API Request

- Login、Register、Refreshのpath、HTTP method、認証要否
- Features、Noticesのlimitとcursor
- cursorがnilの場合と値を持つ場合
- AgreeTermのpath、method、認証要否
- RegisterPushTokenのpath、method、認証要否

## URLSessionAPIClient

- URL、method、既定Header、JSON Body生成
- 認証HeaderへのBearer Token設定
- Tokenがnil／空文字の場合のエラー
- 200番台Responseのデコード
- 400、401、404、500、503のHTTPエラー変換
- 不正JSONのデコードエラー変換

## Persistence

### DefaultUserDefaultsClient

- Bool、String、Arrayの保存と読み戻し
- テスト専用Suiteによる本番データとの分離

### AccessTokenProvider

- KeychainからAccess Tokenを取得
- 読み込み対象Keyの確認

## Repository

### DefaultAuthenticationRepository

- Login RequestとSession生成
- Access Token／Refresh Token保存
- RegisterとRefresh Token更新
- API共通エラーの伝播
- エラー時にTokenを保存しない
- Logout時のKeychain全削除

### DefaultAppInformationRepository

- ResponseからDomain Modelへの変換

### DefaultNoticeRepository / DefaultFeaturesRepository

- limit 20とcursorの送信
- itemsとnextCursorの返却

### DefaultAgreeTermRepository

- termsVersionの送信

### DefaultPushNotificationRepository

- 通知許可要求
- FCM Token、platform、deviceIDの送信

## Store

### DefaultAuthenticationStore

- Login、Register、Token Refresh
- Session保持とログイン状態
- メールアドレスのKeychain保存
- Access Token、Refresh Token、メールアドレス、Terminal ID取得
- Terminal ID生成
- 利用規約同意とLogoutの委譲

### DefaultAppInformationStore

- アプリ情報の保持
- メンテナンス状態
- 最低アプリバージョン
- 強制アップデート判定

### DefaultNoticeStore / DefaultFeaturesStore

- 初回取得による置換
- 追加取得によるappend
- nextCursor更新
- Feature選択状態

### DefaultPushNotificationStore

- 通知許可要求とToken登録の委譲

## AppRouter

- push、pop、指定Destinationへのpop、popToRoot
- 空履歴でのpop
- Loading表示のON／OFF
- Alertのenqueue、dropIfPresenting、replaceCurrent
- Alertの全削除

## ScreenState

### LoginScreenState

- メールアドレスの空・文字数・形式・正常値
- パスワードの空・文字数・形式・正常値
- 入力許可外文字の除去
- Loginボタン活性条件
- Focus状態
- Register遷移
- Login成功時の規約同意済み／未同意分岐
- Push Token登録
- Loading終了

### RegisterScreenState

- 確認パスワードの空・文字数・形式・不一致・一致
- Sign Upボタン活性条件
- Register成功とPush Token登録
- Terms遷移
- 戻る操作

### TermScreenState

- チェック状態とAgreeボタン活性条件
- 認証情報とアプリ情報から利用規約URLを設定
- 利用規約version送信
- Main遷移

### MainScreenState

- Logout実行
- LoginまでNavigation履歴を戻す

### FeaturesScreenState

- 初回取得、空判定、Loading終了
- 最終要素だけで追加取得
- Feature Detail遷移

### NotificationScreenState

- 初回取得とRefresh
- 最終要素だけで追加取得
- Loading終了

### FeatureDetailScreenState

- 選択Feature表示
- Mainまで戻る操作

## Root / Splash

### RootScreenState

- メンテナンスAlert
- 強制アップデートAlert
- Refresh Tokenの有無
- Token更新
- 多重更新フラグの解除

### SplashScreenState

- 通知許可要求
- Terminal ID生成
- アプリ情報取得
- Sessionなしの場合のLogin遷移
- Refresh成功時のMain遷移
- Push Token登録

## Test対象外

- SwiftUI Viewの描画とレイアウト
- Firebase SDK自体の内部動作
- OSの通知許可ダイアログ
- WebViewのHTML描画
- 実ネットワーク探索
- スクリーンショット撮影処理

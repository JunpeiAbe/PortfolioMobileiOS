import Foundation
import UIKit

@MainActor
@Observable
final class SplashScreenState {
    var appRouter: AppRouter
    var appInfomationStore: AppInfomationStore
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    
    init(
        appRouter: AppRouter,
        appInfomationStore: AppInfomationStore,
        authenticationStore: AuthenticationStore
    ) {
        self.appRouter = appRouter
        self.appInfomationStore = appInfomationStore
        self.authenticationStore = authenticationStore
    }
    
    func onAppear() async {
        do {
            // 端末IDのチェック
            if authenticationStore.terminalID == nil {
                authenticationStore.saveTerminalID()
            }
            // アプリ情報取得
            try await appInfomationStore.fetchAppInfomation()
            print("appInfomationStore.appInfomation",appInfomationStore.appInfomation as Any)
            // メンテナンス中フラグtrueの場合
            if appInfomationStore.isMaintenance {
                alertContent = AlertContent.maintenance
            }
            // 最低アプリバージョン > 現在のアプリバージョンの場合
            if appInfomationStore.needsForceUpdate {
                alertContent = AlertContent.forceUpdate {
                    // TODO: アプリストアに遷移する
                    if let url = URL(string: "https://apps.apple.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            // ログイン済判定
            // トークンとメールアドレスが保存されているかどうか
            if let mailAddress = authenticationStore.mailAddress,
               let accessToken = authenticationStore.accessToken {
                try await authenticationStore
                    .login(
                        mailAddress: mailAddress,
                        password: nil,
                        accessToken: accessToken,
                        deviceToken: .init()
                    )
                appRouter.push(.main)
            } else {
                // ログイン画面に遷移
                appRouter.push(.login)
            }
        } catch let error as APIClientError {
            // TODO: error handling
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
            // TODO: error handling
        }
    }
}


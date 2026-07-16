import Foundation
import UIKit

@MainActor
@Observable
final class SplashScreenState {
    var appRouter: AppRouter
    var pushNotificationStore: PushNotificationStore
    var appInformationStore: AppInformationStore
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    
    init(
        appRouter: AppRouter,
        pushNotificationStore: PushNotificationStore,
        appInformationStore: AppInformationStore,
        authenticationStore: AuthenticationStore
    ) {
        self.appRouter = appRouter
        self.pushNotificationStore = pushNotificationStore
        self.appInformationStore = appInformationStore
        self.authenticationStore = authenticationStore
    }
    
    func onAppear() async {
        do {
            // push通知権限の要求
            await pushNotificationStore.requestAuthorization()
            // 端末IDのチェック
            if authenticationStore.terminalID == nil {
                authenticationStore.saveTerminalID()
            }
            // アプリ情報取得
            try await appInformationStore.fetchAppInformation()
            // メンテナンス中フラグtrueの場合
            if appInformationStore.isMaintenance {
                alertContent = AlertContent.maintenance
            }
            // 最低アプリバージョン > 現在のアプリバージョンの場合
            if appInformationStore.needsForceUpdate {
                alertContent = AlertContent.forceUpdate {
                    if let url = URL(string: "https://apps.apple.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            // Keychainにリフレッシュトークンがあればセッションを更新する
            if let refreshToken = authenticationStore.refreshToken {
                do {
                    try await authenticationStore.tokenRefresh(refreshToken: refreshToken)
                    if let deviceID = authenticationStore.terminalID {
                        do {
                            try await pushNotificationStore.registerToken(deviceID: deviceID)
                        } catch {
                        }
                    }
                    appRouter.push(.login)
                    appRouter.push(.main)
                } catch {
                    try? await authenticationStore.logout()
                    appRouter.push(.login)
                }
            } else {
                // ログイン画面に遷移
                appRouter.push(.login)
            }
        } catch let error as APIClientError {
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
        }
    }
}

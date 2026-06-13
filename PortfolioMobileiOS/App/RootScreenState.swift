import SwiftUI

@MainActor
@Observable
final class RootScreenState {
    var loadingState: LoadingState = .idle
    var appInfomationStore: AppInfomationStore
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    
    init(
        appInfomationStore: AppInfomationStore,
        authenticationStore: AuthenticationStore
    ) {
        self.appInfomationStore = appInfomationStore
        self.authenticationStore = authenticationStore
    }
    
    func checkAppStatus() async {
        print("checkAppStatus")
        do {
            try await appInfomationStore.fetchAppInfomation()
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

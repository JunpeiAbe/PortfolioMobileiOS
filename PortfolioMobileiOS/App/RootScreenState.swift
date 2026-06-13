import SwiftUI

@MainActor
@Observable
final class RootScreenState {
    var loadingState: LoadingState = .idle
    var appInfomationStore: AppInfomationStore
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    var isRefreshingAccessToken = false
    
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
    
    func refreshAccessTokenIfNeeded() async {
        guard !isRefreshingAccessToken else { return }
        print("refreshAccessTokenIfNeeded")
        isRefreshingAccessToken = true
        defer {
            isRefreshingAccessToken = false
        }
        
        do {
            if let refreshToken = authenticationStore.refreshToken {
                try await authenticationStore.tokenRefresh(refreshToken: refreshToken)
            }
        } catch let error as APIClientError {
            // TODO: error handling
            print(error)
        } catch {
            // TODO: error handling
            print(error)
        }
    }
}

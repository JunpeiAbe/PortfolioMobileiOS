import SwiftUI

@MainActor
@Observable
final class RootScreenState {
    var loadingState: LoadingState = .idle
    var appInformationStore: AppInformationStore
    var authenticationStore: AuthenticationStore
    var alertContent: PresentAlert?
    var isRefreshingAccessToken = false
    
    init(
        appInformationStore: AppInformationStore,
        authenticationStore: AuthenticationStore
    ) {
        self.appInformationStore = appInformationStore
        self.authenticationStore = authenticationStore
    }
    
    func checkAppStatus() async {
        do {
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
        } catch let error as APIClientError {
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
        }
    }
    
    func refreshAccessTokenIfNeeded() async {
        guard !isRefreshingAccessToken else { return }
        isRefreshingAccessToken = true
        defer {
            isRefreshingAccessToken = false
        }
        
        do {
            if let refreshToken = authenticationStore.refreshToken {
                try await authenticationStore.tokenRefresh(refreshToken: refreshToken)
            }
        } catch let error as APIClientError {
        } catch {
        }
    }
}

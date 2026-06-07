import Foundation
import UIKit

@MainActor
@Observable
final class SplashScreenState {
    var loadingState: LoadingState = .idle
    var appInfomationStore: AppInfomationStore
    var alertContent: PresentAlert?
    
    init(appInfomationStore: AppInfomationStore) {
        self.appInfomationStore = appInfomationStore
    }
    
    func onAppear() {
        Task {
            defer {
                loadingState = .idle
            }
            do {
                loadingState = .loading
                try await appInfomationStore.fetchAppInfomation()
                print("appInfomationStore.appInfomation",appInfomationStore.appInfomation)
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
                loadingState = .failed(error.localizedDescription)
            } catch {
                // TODO: error handling
            }
        }
    }
}


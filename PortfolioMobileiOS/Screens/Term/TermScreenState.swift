import Foundation

@MainActor
@Observable
final class TermScreenState {
    
    var isChecked: Bool = false
    var loadingState: LoadingState = .idle
    var isAgreeButtonDisabled: Bool {
        !isChecked
        || loadingState == .loading
    }
    var appRouter: AppRouter
    var appInfomationStore: AppInfomationStore
    var authenticationStore: AuthenticationStore
    var appTermURL: URL?
    
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
        loadingState = .loading
        defer {
            loadingState = .idle
        }
        // トークンとメールアドレス、利用規約URLの取得
        guard let _ = authenticationStore.mailAddress,
              let _ = authenticationStore.accessToken,
              let url = appInfomationStore.appInfomation?.appTermURL
        else { return }
        appTermURL = URL(string: url)
    }
    
    func checkButtonPressed() {
        isChecked.toggle()
    }
    
    func agreeButtonPressed() {
        loadingState = .loading
        Task {
            defer {
                loadingState = .idle
            }
            do {
                guard let mailAddress = authenticationStore.mailAddress,
                      let accessToken = authenticationStore.accessToken,
                      let termsVersion = appInfomationStore.appInfomation?.appTermVersion
                else { return }
                print("mailAddress:\(mailAddress)")
                print("accessToken:\(accessToken)")
                print("termsVersion:\(termsVersion)")
                // 規約同意
                try await authenticationStore
                    .agreeTerm(
                        termsVersion: termsVersion
                    )
                // ログイン
                try await authenticationStore
                    .login(
                        mailAddress: mailAddress,
                        password: nil,
                        accessToken: accessToken,
                        deviceToken: .init()
                    )
                appRouter.push(.main)
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
}

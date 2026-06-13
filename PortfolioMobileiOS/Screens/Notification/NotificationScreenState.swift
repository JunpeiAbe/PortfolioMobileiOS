import Foundation

@MainActor
@Observable
final class NotificationScreenState {
    private let appRouter: AppRouter
    private let noticeStore: NoticeStore
    private(set) var notices: [Notice] = []
    var loadingState: LoadingState = .idle
    
    init(
        appRouter: AppRouter,
        noticeStore: NoticeStore
    ) {
        self.appRouter = appRouter
        self.noticeStore = noticeStore
    }
    
    func onAppear() async {
        loadingState = .loading
        defer {
            loadingState = .idle
        }
        do {
            try await noticeStore.fetchNotices(nextCursor: nil)
            let notices = noticeStore.notices
            print(notices)
            self.notices.append(contentsOf: notices)
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
    
    func refreshNotices() async {
        await onAppear()
    }
    
    func loadMoreIfNeeded() async {
        loadingState = .loading
        defer {
            loadingState = .idle
        }
        if let nextCursor = noticeStore.nextCursor {
            do {
                try await noticeStore.fetchNotices(nextCursor: nextCursor)
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
        } else {
            // TODO: 追加読み込み対象がないことを示す
        }
    }
}


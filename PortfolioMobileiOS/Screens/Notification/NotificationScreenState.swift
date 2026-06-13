import Foundation

@MainActor
@Observable
final class NotificationScreenState {
    private let appRouter: AppRouter
    private let noticeStore: NoticeStore
    private(set) var notices: [Notice] = []
    var loadingState: LoadingState = .idle
    private(set) var isLoadingMore = false
    var isNoticesEmpty: Bool {
        notices.isEmpty
    }
    
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
            try await noticeStore.fetchNotices()
            let notices = noticeStore.notices
            print(notices.count)
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
        notices = []
        await onAppear()
    }
    
    func loadMoreIfNeeded(currentNotice: Notice) async {
        guard let nextCursor = noticeStore.nextCursor else {
            // TODO: 追加読み込み対象がないことを示す
            return
        }
        guard shouldLoadMore(currentNotice: currentNotice) else {
            // TODO: 追加読み込み対象がないことを示す
            return
        }
        isLoadingMore = true
        defer {
            isLoadingMore = false
        }
        
        do {
            try await noticeStore.loadMore(nextCursor: nextCursor)
            self.notices = noticeStore.notices
            print(notices.count)
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
    
    private func shouldLoadMore(currentNotice: Notice) -> Bool {
        currentNotice.id == notices.last?.id
    }
}


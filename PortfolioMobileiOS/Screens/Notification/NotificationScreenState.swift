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
            self.notices.append(contentsOf: notices)
        } catch let error as APIClientError {
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
        }
    }
    
    func refreshNotices() async {
        notices = []
        await onAppear()
    }
    
    func loadMoreIfNeeded(currentNotice: Notice) async {
        guard let nextCursor = noticeStore.nextCursor else {
            return
        }
        guard shouldLoadMore(currentNotice: currentNotice) else {
            return
        }
        isLoadingMore = true
        defer {
            isLoadingMore = false
        }
        
        do {
            try await noticeStore.loadMore(nextCursor: nextCursor)
            self.notices = noticeStore.notices
        } catch let error as APIClientError {
            switch error {
                // 通信エラーの場合
            case .notConnectedToInternet: break
            default: break
            }
        } catch {
        }
    }
    
    private func shouldLoadMore(currentNotice: Notice) -> Bool {
        currentNotice.id == notices.last?.id
    }
}


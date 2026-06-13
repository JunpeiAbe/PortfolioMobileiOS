import Foundation

@MainActor
@Observable
final class DefaultNoticeStore: NoticeStore {
    private(set) var notices: [Notice] = []
    private(set) var nextCursor: String?
    private let noticeRepository: NoticeRepository
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
    
    func fetchNotices() async throws {
        self.notices = []
        self.nextCursor = nil
        let (notices, nextCursor) = try await noticeRepository.fetchNotices(nextCursor: nil)
        self.notices = notices
        self.nextCursor = nextCursor
    }
    
    func loadMore(nextCursor: String) async throws {
        let (notices, nextCursor) = try await noticeRepository.fetchNotices(nextCursor: nextCursor)
        self.notices.append(contentsOf: notices)
        self.nextCursor = nextCursor
    }
}

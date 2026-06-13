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
    
    func fetchNotices(nextCursor: String?) async throws {
        let (notices, nextCursor) = try await noticeRepository.fetchNotices(nextCursor: nextCursor)
        self.notices = notices
        self.nextCursor = nextCursor
    }
}

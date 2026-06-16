import Foundation

protocol NoticeRepository: Sendable {
    func fetchNotices(nextCursor: String?) async throws -> ([Notice], nextCursor: String?)
}

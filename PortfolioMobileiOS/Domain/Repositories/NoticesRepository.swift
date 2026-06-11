import Foundation

protocol NoticesRepository: Sendable {
    func fetchNotices(nextCursor: String?) async throws -> ([Notice], nextCursor: String?)
}


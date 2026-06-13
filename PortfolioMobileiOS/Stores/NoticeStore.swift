import Foundation

@MainActor
protocol NoticeStore {
    var notices: [Notice] { get }
    var nextCursor: String? { get }
    func fetchNotices(nextCursor: String?) async throws
}

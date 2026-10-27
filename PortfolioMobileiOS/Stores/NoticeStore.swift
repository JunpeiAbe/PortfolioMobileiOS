import Foundation

@MainActor
protocol NoticeStore: Sendable {
    var notices: [Notice] { get }
    var nextCursor: String? { get }
    func fetchNotices() async throws
    func loadMore(nextCursor: String) async throws
}

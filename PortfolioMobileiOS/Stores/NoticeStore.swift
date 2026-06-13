import Foundation

@MainActor
protocol NoticeStore {
    var notices: [Notice] { get }
    var nextCursor: String? { get }
    func fetchNotices() async throws
    func loadMore(nextCursor: String) async throws
}

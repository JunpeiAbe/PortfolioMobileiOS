import Foundation

struct DefaultNoticeRepository: NoticeRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchNotices(nextCursor: String?) async throws -> ([Notice], nextCursor: String?) {
        let response = try await apiClient.send(
            NoticesRequest(
                limit: 20,
                cursor: nextCursor
            )
        )
        if let error = response.error {
            throw error
        }
        return (response.items, response.nextCursor)
    }
}

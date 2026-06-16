import Foundation

struct DefaultFeaturesRepository: FeaturesRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchFeatures(nextCursor: String?) async throws -> ([Feature], nextCursor: String?) {
        let response = try await apiClient.send(
            FeaturesRequest(
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


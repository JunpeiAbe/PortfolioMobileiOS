import Foundation

@MainActor
@Observable
final class DefaultFeaturesStore: FeaturesStore {
    private(set) var features: [Feature] = []
    private(set) var nextCursor: String?
    private let featuresRepository: FeaturesRepository
    
    init(featuresRepository: FeaturesRepository) {
        self.featuresRepository = featuresRepository
    }
    
    func fetchFeatures() async throws {
        self.features = []
        self.nextCursor = nil
        let (features, nextCursor) = try await featuresRepository.fetchFeatures(nextCursor: nil)
        self.features = features
        self.nextCursor = nextCursor
    }
    
    func loadMore(nextCursor: String) async throws {
        let (features, nextCursor) = try await featuresRepository.fetchFeatures(nextCursor: nextCursor)
        self.features.append(contentsOf: features)
        self.nextCursor = nextCursor
    }
}

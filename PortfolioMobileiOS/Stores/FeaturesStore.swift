import Foundation

@MainActor
protocol FeaturesStore {
    var features: [Feature] { get }
    var nextCursor: String? { get }
    func fetchFeatures() async throws
    func loadMore(nextCursor: String) async throws
}

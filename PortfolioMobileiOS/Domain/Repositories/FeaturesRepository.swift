import Foundation

protocol FeaturesRepository: Sendable {
    func fetchFeatures(nextCursor: String?) async throws -> ([Feature], nextCursor: String?)
}


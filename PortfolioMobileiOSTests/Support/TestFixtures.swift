import Foundation
@testable import PortfolioMobileiOS

enum TestFixtures {
    static func feature(_ id: String = "feature-1", title: String = "Location") -> Feature {
        Feature(id: id, title: title, category: .location)
    }

    static func notice(_ id: String = "notice-1", title: String = "Notice") -> Notice {
        Notice(id: id, title: title, summary: "Summary", body: "Body", category: .service, publishedAt: "2026-06-13T10:00:00Z", thumbnailURL: nil)
    }
}

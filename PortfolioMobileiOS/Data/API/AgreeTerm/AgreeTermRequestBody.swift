import Foundation

struct AgreeTermRequestBody: Codable {
    let termsVersion: String

    enum CodingKeys: String, CodingKey {
        case termsVersion = "terms_version"
    }
}


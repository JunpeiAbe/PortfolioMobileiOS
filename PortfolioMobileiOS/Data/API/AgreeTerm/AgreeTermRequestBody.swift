import Foundation

struct AgreeTermRequestBody: Codable {
    let mailAddress: String
    let termsVersion: String

    enum CodingKeys: String, CodingKey {
        case mailAddress = "mail_address"
        case termsVersion = "terms_version"
    }
}


import Foundation

struct CommonResponseError: Codable {
    let code: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}


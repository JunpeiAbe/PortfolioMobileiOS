import Foundation

struct CommonResponseError: Codable, Error {
    let code: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}


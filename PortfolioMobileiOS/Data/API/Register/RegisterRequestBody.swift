import Foundation

struct RegisterRequestBody: Codable {
    let mailAddress: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case mailAddress = "mail_address"
        case password
    }
}

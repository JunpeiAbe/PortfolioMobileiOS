import Foundation

struct RegisterRequest: Codable {
    let mailAddress: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case mailAddress = "mail_address"
        case password
    }
}

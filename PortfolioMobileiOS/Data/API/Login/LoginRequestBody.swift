import Foundation

struct LoginRequestBody: Codable {
    let mailAddress: String
    let password: String
    let deviceToken: String?

    enum CodingKeys: String, CodingKey {
        case mailAddress = "mail_address"
        case password
        case deviceToken = "device_token"
    }
}

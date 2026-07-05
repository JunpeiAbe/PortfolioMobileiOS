import Foundation

struct RegisterPushTokenRequestBody: Codable {
    let token: String
    let platform: String
    let deviceID: String

    enum CodingKeys: String, CodingKey {
        case token
        case platform
        case deviceID = "device_id"
    }
}

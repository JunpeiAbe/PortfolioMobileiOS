import Foundation

struct LoginRequestBody: Codable {
    let mailAddress: String
    let password: String?
    let accessToken: String?
    let deviceToken: String?
    
    init(
        mailAddress: String,
        password: String?,
        deviceToken: String
    ) {
        self.mailAddress = mailAddress
        self.password = password
        self.accessToken = nil
        self.deviceToken = deviceToken
    }
    
    init(
        mailAddress: String,
        accessToken: String?,
        deviceToken: String
    ) {
        self.mailAddress = mailAddress
        self.password = nil
        self.accessToken = accessToken
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case mailAddress = "mail_address"
        case password
        case accessToken = "access_token"
        case deviceToken = "device_token"
    }
}


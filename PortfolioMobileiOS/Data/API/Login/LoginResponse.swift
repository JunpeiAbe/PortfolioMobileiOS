import Foundation

struct LoginResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    let appTermsAgreed: Bool?
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case appTermsAgreed = "app_terms_agreed"
        case error
    }
}


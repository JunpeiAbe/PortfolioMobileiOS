import Foundation

struct RefreshResponse: APIResponse {
    let accessToken: String?
    let refreshToken: String?
    let appTermsAgreed: Bool?
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case appTermsAgreed = "app_terms_agreed"
        case error
    }
}

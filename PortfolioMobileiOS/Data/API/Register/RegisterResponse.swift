import Foundation

struct RegisterResponse: APIResponse {
    let accessToken: String?
    let refreshToken: String?
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case error
    }
}

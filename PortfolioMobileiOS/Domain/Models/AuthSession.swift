import Foundation

struct AuthSession: Equatable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int?
    let appTermsAgreed: Bool?
}

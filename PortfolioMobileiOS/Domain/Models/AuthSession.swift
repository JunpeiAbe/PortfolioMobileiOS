import Foundation

struct AuthSession: Equatable {
    let accessToken: String?
    let refreshToken: String?
    let appTermsAgreed: Bool?
}

import Foundation
import Testing
@testable import PortfolioMobileiOS

@Suite("API requests")
struct APIRequestTests {
    // 認証系Requestのpath・method・認証要否をまとめて検証する。
    @Test func authenticationRequests() {
        let login = LoginRequest(httpBody: .init(mailAddress: "a@b.co", password: "Abcdef1!"))
        #expect(login.path == "auth/login")
        #expect(login.httpMethod == .post)
        #expect(!login.requiresAuthorization)

        let register = RegisterRequest(httpBody: .init(mailAddress: "a@b.co", password: "Abcdef1!"))
        #expect(register.path == "auth/register")
        #expect(register.httpMethod == .post)
        #expect(!register.requiresAuthorization)

        let refresh = RefreshRequest(httpBody: .init(refreshToken: "refresh"))
        #expect(refresh.path == "auth/refresh")
        #expect(refresh.httpMethod == .post)
        #expect(!refresh.requiresAuthorization)
    }

    // 一覧Requestがcursorの有無に応じてqueryを生成することを検証する。
    @Test(arguments: [nil, "next-cursor"] as [String?])
    func paginatedRequests(cursor: String?) {
        let features = FeaturesRequest(limit: 20, cursor: cursor)
        let notices = NoticesRequest(limit: 20, cursor: cursor)
        let expected = cursor == nil ? 1 : 2
        #expect(features.queryItems.count == expected)
        #expect(notices.queryItems.count == expected)
        #expect(features.queryItems.first == URLQueryItem(name: "limit", value: "20"))
        #expect(features.queryItems.last(where: { $0.name == "cursor" })?.value == cursor)
        #expect(features.requiresAuthorization)
        #expect(notices.requiresAuthorization)
    }

    // 利用規約同意とPush Token登録Requestの仕様を検証する。
    @Test func authorizedMutationRequests() {
        let terms = AgreeTermRequest(httpBody: .init(termsVersion: "1.0.0"))
        #expect(terms.path == "terms/agree")
        #expect(terms.httpMethod == .post)
        #expect(terms.requiresAuthorization)

        let push = RegisterPushTokenRequest(httpBody: .init(token: "token", platform: "ios", deviceID: "device"))
        #expect(push.path == "devices/push-token")
        #expect(push.httpMethod == .put)
        #expect(push.requiresAuthorization)
    }
}

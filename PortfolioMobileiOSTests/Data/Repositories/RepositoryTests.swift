import Foundation
import Testing
@testable import PortfolioMobileiOS

@Suite("Repositories", .serialized)
struct RepositoryTests {
    // Login成功時にRequest内容、Session生成、Token保存を行うことを検証する。
    @Test func authenticationLoginSuccess() async throws {
        let api = APIClientSpy()
        api.handler = { request in
            let request = request as! LoginRequest
            #expect(request.httpBody?.mailAddress == "user@example.com")
            #expect(request.httpBody?.password == "Abcdef1!")
            return LoginResponse(accessToken: "access", refreshToken: "refresh", appTermsAgreed: true, error: nil)
        }
        let keychain = KeychainClientSpy()
        let repository = DefaultAuthenticationRepository(apiClient: api, keychainclient: keychain)
        let session = try await repository.login(mailAddress: "user@example.com", password: "Abcdef1!")
        #expect(session == AuthSession(accessToken: "access", refreshToken: "refresh", appTermsAgreed: true))
        #expect(keychain.storage[.accessToken] == "access")
        #expect(keychain.storage[.refreshToken] == "refresh")
    }

    // RegisterとRefreshが対応するRequestを送り、新しいTokenを保存することを検証する。
    @Test func authenticationRegisterAndRefresh() async throws {
        let api = APIClientSpy()
        api.handler = { request in
            if request is RegisterRequest {
                return RegisterResponse(accessToken: "registered-access", refreshToken: "registered-refresh", error: nil)
            }
            let refresh = request as! RefreshRequest
            #expect(refresh.httpBody?.refreshToken == "old-refresh")
            return RefreshResponse(accessToken: "new-access", refreshToken: "new-refresh", appTermsAgreed: false, error: nil)
        }
        let keychain = KeychainClientSpy()
        let repository = DefaultAuthenticationRepository(apiClient: api, keychainclient: keychain)
        _ = try await repository.register(mailAddress: "user@example.com", password: "Abcdef1!")
        #expect(keychain.storage[.accessToken] == "registered-access")
        let refreshed = try await repository.tokenRefresh(refreshToken: "old-refresh")
        #expect(refreshed.refreshToken == "new-refresh")
        #expect(keychain.storage[.accessToken] == "new-access")
    }

    // API共通エラーがある場合にTokenを保存せず、そのエラーを投げることを検証する。
    @Test func authenticationCommonError() async {
        let api = APIClientSpy()
        api.handler = { _ in LoginResponse(accessToken: nil, refreshToken: nil, appTermsAgreed: nil, error: .init(code: "AUTH", message: "failed")) }
        let keychain = KeychainClientSpy()
        let repository = DefaultAuthenticationRepository(apiClient: api, keychainclient: keychain)
        await #expect(throws: CommonResponseError.self) {
            _ = try await repository.login(mailAddress: "user@example.com", password: "Abcdef1!")
        }
        #expect(keychain.savedValues.isEmpty)
    }

    // Logout時にKeychainを全削除することを検証する。
    @Test func authenticationLogout() async throws {
        let keychain = KeychainClientSpy()
        let repository = DefaultAuthenticationRepository(apiClient: APIClientSpy(), keychainclient: keychain)
        try await repository.logout()
        #expect(keychain.deleteAllCallCount == 1)
    }

    // アプリ情報ResponseをDomain Modelへ変換することを検証する。
    @Test func appInformation() async throws {
        let api = APIClientSpy()
        api.handler = { _ in
            AppInformationResponse(isMaintenance: true, androidMinAppVersion: nil, iOSMinAppVersion: "2.0.0", appTermURL: "https://example.com/terms", appTermVersion: "2", qaURL: "https://example.com/qa", error: nil)
        }
        let result = try await DefaultAppInformationRepository(apiClient: api).fetchAppInformation()
        #expect(result.isMaintenance == true)
        #expect(result.iOSMinAppVersion == "2.0.0")
        #expect(result.appTermVersion == "2")
    }

    // NoticeとFeatureのRepositoryが20件・cursor付きRequestを送ることを検証する。
    @Test func paginatedRepositories() async throws {
        let api = APIClientSpy()
        api.handler = { request in
            if let request = request as? NoticesRequest {
                #expect(request.limit == 20)
                #expect(request.cursor == "notice-cursor")
                return NoticesResponse(items: [TestFixtures.notice()], nextCursor: "next-notice", error: nil)
            }
            let request = request as! FeaturesRequest
            #expect(request.limit == 20)
            #expect(request.cursor == "feature-cursor")
            return FeaturesResponse(items: [TestFixtures.feature()], nextCursor: "next-feature", error: nil)
        }
        let notices = try await DefaultNoticeRepository(apiClient: api).fetchNotices(nextCursor: "notice-cursor")
        let features = try await DefaultFeaturesRepository(apiClient: api).fetchFeatures(nextCursor: "feature-cursor")
        #expect(notices.0.count == 1)
        #expect(notices.nextCursor == "next-notice")
        #expect(features.0.count == 1)
        #expect(features.nextCursor == "next-feature")
    }

    // 利用規約同意でversionをBodyへ設定することを検証する。
    @Test func agreeTerm() async throws {
        let api = APIClientSpy()
        api.handler = { request in
            let request = request as! AgreeTermRequest
            #expect(request.httpBody?.termsVersion == "2.0.0")
            return AgreeTermResponse(error: nil)
        }
        try await DefaultAgreeTermRepository(apiClient: api).agreeTerm(termsVersion: "2.0.0")
    }

    // Push Token取得後にdeviceID、platform、tokenをAPIへ送ることを検証する。
    @Test func pushNotificationRegistration() async throws {
        let push = PushNotificationClientSpy()
        let api = APIClientSpy()
        api.handler = { request in
            let request = request as! RegisterPushTokenRequest
            #expect(request.httpBody?.token == "fcm-token")
            #expect(request.httpBody?.platform == "ios")
            #expect(request.httpBody?.deviceID == "device-id")
            return RegisterPushTokenResponse(error: nil)
        }
        let repository = DefaultPushNotificationRepository(pushNotificationClient: push, apiClient: api)
        await repository.requestAuthorization()
        try await repository.registerToken(deviceID: "device-id")
        #expect(push.authorizationCallCount == 1)
    }
}

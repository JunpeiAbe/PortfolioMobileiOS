import Foundation
@testable import PortfolioMobileiOS

final class APIClientSpy: APIClient, @unchecked Sendable {
    var requests: [Any] = []
    var handler: ((Any) throws -> Any)?

    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        requests.append(request)
        guard let response = try handler?(request) as? Request.Response else {
            throw TestError.expected
        }
        return response
    }
}

final class AuthenticationRepositorySpy: AuthenticationRepository, @unchecked Sendable {
    var session = AuthSession(accessToken: "access", refreshToken: "refresh", appTermsAgreed: false)
    var error: (any Error)?
    var loginArguments: [(String, String)] = []
    var registerArguments: [(String, String)] = []
    var refreshArguments: [String] = []
    var logoutCallCount = 0

    func login(mailAddress: String, password: String) async throws -> AuthSession {
        loginArguments.append((mailAddress, password))
        if let error { throw error }
        return session
    }
    func register(mailAddress: String, password: String) async throws -> AuthSession {
        registerArguments.append((mailAddress, password))
        if let error { throw error }
        return session
    }
    func tokenRefresh(refreshToken: String) async throws -> AuthSession {
        refreshArguments.append(refreshToken)
        if let error { throw error }
        return session
    }
    func logout() async throws {
        logoutCallCount += 1
        if let error { throw error }
    }
}

final class AgreeTermRepositorySpy: AgreeTermRepository, @unchecked Sendable {
    var versions: [String] = []
    var error: (any Error)?
    func agreeTerm(termsVersion: String) async throws {
        versions.append(termsVersion)
        if let error { throw error }
    }
}

final class AppInformationRepositorySpy: AppInformationRepository, @unchecked Sendable {
    var information = AppInformation(isMaintenance: false, iOSMinAppVersion: "1.0.0", appTermURL: "https://example.com/terms", appTermVersion: "1.0.0", qaURL: nil)
    var error: (any Error)?
    var callCount = 0
    func fetchAppInformation() async throws -> AppInformation {
        callCount += 1
        if let error { throw error }
        return information
    }
}

final class NoticeRepositorySpy: NoticeRepository, @unchecked Sendable {
    var responses: [([Notice], String?)] = []
    var cursors: [String?] = []
    var error: (any Error)?
    func fetchNotices(nextCursor: String?) async throws -> ([Notice], nextCursor: String?) {
        cursors.append(nextCursor)
        if let error { throw error }
        return responses.isEmpty ? ([], nil) : responses.removeFirst()
    }
}

final class FeaturesRepositorySpy: FeaturesRepository, @unchecked Sendable {
    var responses: [([Feature], String?)] = []
    var cursors: [String?] = []
    var error: (any Error)?
    func fetchFeatures(nextCursor: String?) async throws -> ([Feature], nextCursor: String?) {
        cursors.append(nextCursor)
        if let error { throw error }
        return responses.isEmpty ? ([], nil) : responses.removeFirst()
    }
}

final class PushNotificationClientSpy: PushNotificationClient, @unchecked Sendable {
    var authorizationCallCount = 0
    var token = "fcm-token"
    var error: (any Error)?
    func requestAuthorization() async { authorizationCallCount += 1 }
    func fetchFCMToken() async throws -> String {
        if let error { throw error }
        return token
    }
}

final class PushNotificationRepositorySpy: PushNotificationRepository, @unchecked Sendable {
    var authorizationCallCount = 0
    var deviceIDs: [String] = []
    var error: (any Error)?
    func requestAuthorization() async { authorizationCallCount += 1 }
    func registerToken(deviceID: String) async throws {
        deviceIDs.append(deviceID)
        if let error { throw error }
    }
}

import Foundation
@testable import PortfolioMobileiOS

@MainActor
final class AuthenticationStoreSpy: AuthenticationStore {
    var authSession: AuthSession?
    var isLoggedIn: Bool { authSession?.accessToken != nil }
    var terminalID: String?
    var accessToken: String?
    var refreshToken: String?
    var mailAddress: String?
    var appTermsAgreed: Bool { authSession?.appTermsAgreed ?? false }
    var loginArguments: [(String, String)] = []
    var registerArguments: [(String, String)] = []
    var refreshArguments: [String] = []
    var agreeVersions: [String] = []
    var logoutCallCount = 0
    var saveTerminalIDCallCount = 0
    var error: (any Error)?

    func login(mailAddress: String, password: String) async throws {
        loginArguments.append((mailAddress, password)); if let error { throw error }
    }
    func register(mailAddress: String, password: String) async throws {
        registerArguments.append((mailAddress, password)); if let error { throw error }
    }
    func tokenRefresh(refreshToken: String) async throws {
        refreshArguments.append(refreshToken); if let error { throw error }
    }
    func logout() async throws { logoutCallCount += 1; if let error { throw error } }
    func agreeTerm(termsVersion: String) async throws { agreeVersions.append(termsVersion); if let error { throw error } }
    func saveTerminalID() { saveTerminalIDCallCount += 1; terminalID = "generated" }
}

@MainActor
final class AppInformationStoreSpy: AppInformationStore {
    var appInformation: AppInformation?
    var currentAppVersion: AppVersion?
    var latestAppVersion: AppVersion?
    var needsForceUpdate = false
    var isMaintenance = false
    var callCount = 0
    var error: (any Error)?
    func fetchAppInformation() async throws {
        callCount += 1
        if let error { throw error }
    }
}

@MainActor
final class NoticeStoreSpy: NoticeStore {
    var notices: [Notice] = []
    var nextCursor: String?
    var fetchCallCount = 0
    var loadCursors: [String] = []
    var error: (any Error)?
    func fetchNotices() async throws { fetchCallCount += 1; if let error { throw error } }
    func loadMore(nextCursor: String) async throws { loadCursors.append(nextCursor); if let error { throw error } }
}

@MainActor
final class FeaturesStoreSpy: FeaturesStore {
    var features: [Feature] = []
    var selectedFeature: Feature?
    var nextCursor: String?
    var fetchCallCount = 0
    var loadCursors: [String] = []
    var error: (any Error)?
    func fetchFeatures() async throws { fetchCallCount += 1; if let error { throw error } }
    func loadMore(nextCursor: String) async throws { loadCursors.append(nextCursor); if let error { throw error } }
}

@MainActor
final class PushNotificationStoreSpy: PushNotificationStore {
    var authorizationCallCount = 0
    var deviceIDs: [String] = []
    var error: (any Error)?
    func requestAuthorization() async { authorizationCallCount += 1 }
    func registerToken(deviceID: String) async throws { deviceIDs.append(deviceID); if let error { throw error } }
}

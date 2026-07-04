import Foundation

@MainActor
protocol AuthenticationStore {
    var authSession: AuthSession? { get }
    var isLoggedIn: Bool { get }
    var terminalID: String? { get }
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var mailAddress: String? { get }
    var appTermsAgreed: Bool { get }
    func login(mailAddress: String, password: String, deviceToken: String) async throws
    func register(mailAddress: String, password: String) async throws
    func tokenRefresh(refreshToken: String) async throws
    func logout() async throws
    func agreeTerm(termsVersion: String) async throws
    func saveTerminalID()
}

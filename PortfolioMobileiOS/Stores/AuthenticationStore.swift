import Foundation

@MainActor
protocol AuthenticationStore {
    var authSession: AuthSession? { get }
    var isLoggedIn: Bool { get }
    func login(mailAddress: String, password: String, deviceToken: String) async throws
    func register(mailAddress: String, password: String) async throws
    func tokenRefresh(refreshToken: String) async throws
    func agreeTerm(mailAddress: String, termsVersion: String) async throws
}

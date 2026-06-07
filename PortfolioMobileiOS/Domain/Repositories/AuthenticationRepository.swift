import Foundation

protocol AuthenticationRepository: Sendable {
    func login(mailAddress: String, password: String?, accessToken: String?, deviceToken: String) async throws -> AuthSession
    func register(mailAddress: String, password: String) async throws -> AuthSession
    func tokenRefresh(refreshToken: String) async throws -> AuthSession
    func logout() async throws
}

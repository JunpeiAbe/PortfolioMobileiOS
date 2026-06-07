import Foundation
@MainActor
@Observable
final class DefaultAuthenticationStore: AuthenticationStore {
    private let authenticationRepository: AuthenticationRepository
    private let agreeTermRepository: AgreeTermRepository
    private(set) var authSession: AuthSession?
    var isLoggedIn: Bool {
        authSession?.accessToken != nil
    }
    
    init(
        authenticationRepository: AuthenticationRepository,
        agreeTermRepository: AgreeTermRepository
    ) {
        self.authenticationRepository = authenticationRepository
        self.agreeTermRepository = agreeTermRepository
    }
    
    func login(mailAddress: String, password: String, deviceToken: String) async throws {
        let session = try await authenticationRepository.login(
            mailAddress: mailAddress,
            password: password,
            deviceToken: deviceToken
        )
        authSession = session
    }
    
    func register(mailAddress: String, password: String) async throws {
        let session = try await authenticationRepository.register(
            mailAddress: mailAddress,
            password: password
        )
        authSession = session
    }
    
    func tokenRefresh(refreshToken: String) async throws {
        let session = try await authenticationRepository.tokenRefresh(refreshToken: refreshToken)
        authSession = session
    }
    
    func logout() async throws {
        try await authenticationRepository.logout()
    }
    
    func agreeTerm(mailAddress: String, termsVersion: String) async throws {
        try await agreeTermRepository.agreeTerm(mailAddress: mailAddress, termsVersion: termsVersion)
    }
}


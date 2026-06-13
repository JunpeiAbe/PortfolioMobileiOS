import Foundation
@MainActor
@Observable
final class DefaultAuthenticationStore: AuthenticationStore {
    private let authenticationRepository: AuthenticationRepository
    private let agreeTermRepository: AgreeTermRepository
    private let userDefaultClient: UserDefaultsClient
    private let keychainClient: KeychainClient
    private(set) var authSession: AuthSession?
    var isLoggedIn: Bool {
        authSession?.accessToken != nil
    }
    var terminalID: String? {
        return userDefaultClient.string(for: .terminalID)
    }
    var accessToken: String? {
        do {
            return try keychainClient.load(for: .accessToken)
        } catch {
            return nil
        }
    }
    var refreshToken: String? {
        do {
            return try keychainClient.load(for: .refreshToken)
        } catch {
            return nil
        }
    }
    var mailAddress: String? {
        do {
            return try keychainClient.load(for: .mailAddress)
        } catch {
            return nil
        }
    }
    var appTermsAgreed: Bool {
        authSession?.appTermsAgreed ?? false
    }
    
    init(
        authenticationRepository: AuthenticationRepository,
        agreeTermRepository: AgreeTermRepository,
        userDefaultClient: UserDefaultsClient,
        keychainClient: KeychainClient
    ) {
        self.authenticationRepository = authenticationRepository
        self.agreeTermRepository = agreeTermRepository
        self.userDefaultClient = userDefaultClient
        self.keychainClient = keychainClient
    }
    
    func login(mailAddress: String, password: String?, accessToken: String?, deviceToken: String) async throws {
        let session = try await authenticationRepository.login(
            mailAddress: mailAddress,
            password: password,
            accessToken: accessToken,
            deviceToken: deviceToken
        )
        authSession = session
        try keychainClient.save(mailAddress, for: .mailAddress)
    }
    
    func register(mailAddress: String, password: String) async throws {
        let session = try await authenticationRepository.register(
            mailAddress: mailAddress,
            password: password
        )
        authSession = session
        try keychainClient.save(mailAddress, for: .mailAddress)
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
    
    func saveTerminalID() {
        userDefaultClient.set(UUID().uuidString, for: .terminalID)
    }
}


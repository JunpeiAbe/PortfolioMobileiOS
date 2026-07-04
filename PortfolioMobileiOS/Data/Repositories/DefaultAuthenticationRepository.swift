import Foundation

struct DefaultAuthenticationRepository: AuthenticationRepository {
    private let apiClient: APIClient
    private let keychainclient: KeychainClient
    
    init(
        apiClient: APIClient,
        keychainclient: KeychainClient
    ) {
        self.apiClient = apiClient
        self.keychainclient = keychainclient
    }
    
    func login(mailAddress: String, password: String, deviceToken: String) async throws -> AuthSession {
        let response = try await apiClient.send(
            LoginRequest(
                httpBody: .init(
                    mailAddress: mailAddress,
                    password: password,
                    deviceToken: deviceToken
                )
            )
        )
        if let error = response.error {
            throw error
        }
        if let accessToken = response.accessToken,
           let refreshToken = response.refreshToken {
            try keychainclient.save(accessToken, for: .accessToken)
            try keychainclient.save(refreshToken, for: .refreshToken)
        }
        return AuthSession(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            appTermsAgreed: response.appTermsAgreed
        )
    }
    
    func register(mailAddress: String, password: String) async throws -> AuthSession {
        let response = try await apiClient.send(
            RegisterRequest(
                httpBody: .init(
                    mailAddress: mailAddress,
                    password: password
                )
            )
        )
        if let error = response.error {
            throw error
        }
        if let accessToken = response.accessToken,
           let refreshToken = response.refreshToken {
            try keychainclient.save(accessToken, for: .accessToken)
            try keychainclient.save(refreshToken, for: .refreshToken)
        }
        return AuthSession(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            appTermsAgreed: nil
        )
    }
    
    func tokenRefresh(refreshToken: String) async throws -> AuthSession {
        let response = try await apiClient.send(
            RefreshRequest(
                httpBody: .init(
                    refreshToken: refreshToken
                )
            )
        )
        if let error = response.error {
            throw error
        }
        if let accessToken = response.accessToken,
           let refreshToken = response.refreshToken {
            try keychainclient.save(accessToken, for: .accessToken)
            try keychainclient.save(refreshToken, for: .refreshToken)
        }
        return AuthSession(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            appTermsAgreed: response.appTermsAgreed
        )
    }
    
    func logout() async throws {
        try keychainclient.deleteAll()
    }
}

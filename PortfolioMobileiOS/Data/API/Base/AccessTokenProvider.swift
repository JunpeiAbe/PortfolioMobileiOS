import Foundation

struct AccessTokenProvider: AccessTokenProviding {
    
    private let keychainClient: KeychainClient
    
    init(keychainClient: KeychainClient) {
        self.keychainClient = keychainClient
    }
    
    func getAccessToken() async throws -> String? {
        return try keychainClient.load(for: .accessToken)
    }
}

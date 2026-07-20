import Foundation
import Testing
@testable import PortfolioMobileiOS

@Suite("Persistence", .serialized)
struct PersistenceTests {
    // UserDefaults ClientがBool・String・Arrayを保存して読み戻すことを検証する。
    @Test func userDefaultsRoundTrip() throws {
        let suite = "PortfolioMobileiOSTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let client = DefaultUserDefaultsClient(userDefaults: defaults)
        client.set(true, for: .terminalID)
        #expect(client.bool(for: .terminalID))
        client.set("terminal", for: .terminalID)
        #expect(client.string(for: .terminalID) == "terminal")
        client.set(["a", "b"], for: .terminalID)
        #expect(client.array(for: .terminalID, as: String.self) == ["a", "b"])
    }

    // AccessTokenProviderがKeychainのaccessTokenを返すことを検証する。
    @Test func accessTokenProvider() async throws {
        let keychain = KeychainClientSpy()
        keychain.storage[.accessToken] = "access"
        let provider = AccessTokenProvider(keychainClient: keychain)
        #expect(try await provider.getAccessToken() == "access")
        #expect(keychain.loadedKeys == [.accessToken])
    }
}

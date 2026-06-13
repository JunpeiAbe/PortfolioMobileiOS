import Foundation

struct StubKeychainClient: KeychainClient {
    func save(_ value: String, for key: KeychainKey) throws {}
    func load(for key: KeychainKey) throws -> String? {
        return "stub_key"
    }
    func delete(for key: KeychainKey) throws {}
    func deleteAll() throws {}
}

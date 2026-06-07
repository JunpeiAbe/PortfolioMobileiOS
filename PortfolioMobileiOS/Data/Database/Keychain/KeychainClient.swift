import Foundation

protocol KeychainClient: Sendable {
    func save(_ value: String, for key: KeychainKey) async throws
    func load(for key: KeychainKey) async throws -> String?
    func delete(for key: KeychainKey) async throws
    func deleteAll() async throws
}

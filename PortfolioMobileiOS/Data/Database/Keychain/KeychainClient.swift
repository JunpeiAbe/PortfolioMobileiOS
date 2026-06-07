import Foundation

protocol KeychainClient: Sendable {
    func save(_ value: String, for key: KeychainKey) throws
    func load(for key: KeychainKey) throws -> String?
    func delete(for key: KeychainKey) throws
    func deleteAll() throws
}

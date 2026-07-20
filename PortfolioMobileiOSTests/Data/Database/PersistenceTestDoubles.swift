import Foundation
@testable import PortfolioMobileiOS

final class KeychainClientSpy: KeychainClient, @unchecked Sendable {
    var storage: [KeychainKey: String] = [:]
    var savedValues: [(String, KeychainKey)] = []
    var loadedKeys: [KeychainKey] = []
    var deletedKeys: [KeychainKey] = []
    var deleteAllCallCount = 0
    var error: (any Error)?

    func save(_ value: String, for key: KeychainKey) throws {
        if let error { throw error }
        savedValues.append((value, key))
        storage[key] = value
    }

    func load(for key: KeychainKey) throws -> String? {
        if let error { throw error }
        loadedKeys.append(key)
        return storage[key]
    }

    func delete(for key: KeychainKey) throws {
        if let error { throw error }
        deletedKeys.append(key)
        storage[key] = nil
    }

    func deleteAll() throws {
        if let error { throw error }
        deleteAllCallCount += 1
        storage.removeAll()
    }
}

final class UserDefaultsClientSpy: UserDefaultsClient, @unchecked Sendable {
    var bools: [UserDefaultsKey: Bool] = [:]
    var strings: [UserDefaultsKey: String] = [:]
    var arrays: [UserDefaultsKey: [Any]] = [:]

    func bool(for key: UserDefaultsKey) -> Bool { bools[key] ?? false }
    func set(_ value: Bool, for key: UserDefaultsKey) { bools[key] = value }
    func string(for key: UserDefaultsKey) -> String? { strings[key] }
    func set(_ value: String?, for key: UserDefaultsKey) { strings[key] = value }
    func array<Value>(for key: UserDefaultsKey, as type: Value.Type) -> [Value] { arrays[key] as? [Value] ?? [] }
    func set<Value>(_ value: [Value], for key: UserDefaultsKey) { arrays[key] = value }
}

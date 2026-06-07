import Foundation

protocol UserDefaultsClient: Sendable {
    func bool(for key: UserDefaultsKey) -> Bool
    func set(_ value: Bool, for key: UserDefaultsKey)
    func string(for key: UserDefaultsKey) -> String?
    func set(_ value: String?, for key: UserDefaultsKey)
    func array<Value>(for key: UserDefaultsKey, as type: Value.Type) -> [Value]
    func set<Value>(_ value: [Value], for key: UserDefaultsKey)
}

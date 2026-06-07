import Foundation

struct DefaultUserDefaultsClient: UserDefaultsClient, @unchecked Sendable {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func bool(for key: UserDefaultsKey) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }
    
    func set(_ value: Bool, for key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func string(for key: UserDefaultsKey) -> String? {
        userDefaults.string(forKey: key.rawValue)
    }
    
    func set(_ value: String?, for key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    
    func array<Value>(
        for key: UserDefaultsKey,
        as type: Value.Type
    ) -> [Value] {
        userDefaults.array(forKey: key.rawValue) as? [Value] ?? []
    }

    func set<Value>(
        _ value: [Value],
        for key: UserDefaultsKey
    ) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}

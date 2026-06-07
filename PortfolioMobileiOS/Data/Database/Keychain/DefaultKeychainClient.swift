import Foundation
import Security

struct DefaultKeychainClient: KeychainClient {
    private let service: String

    init(service: String = Bundle.main.bundleIdentifier ?? "keychain client") {
        self.service = service
    }

    func save(_ value: String, for key: KeychainKey) throws {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        // 更新が完了したので処理酒量
        if status == errSecSuccess {
            return
        }
        // 更新対象がないため新規追加保存
        if status == errSecItemNotFound {
            var addQuery = query
            addQuery[kSecValueData as String] = data

            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)

            guard addStatus == errSecSuccess else {
                throw KeychainError.unhandledStatus(addStatus)
            }

            return
        }

        throw KeychainError.unhandledStatus(status)
    }

    func load(for key: KeychainKey) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.unhandledStatus(status)
        }

        guard let data = result as? Data else {
            throw KeychainError.invalidData
        }

        return String(data: data, encoding: .utf8)
    }

    func delete(for key: KeychainKey) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledStatus(status)
        }
    }

    func deleteAll() throws {
        for key in KeychainKey.allCases {
            try delete(for: key)
        }
    }
}

import Foundation

struct MailAddressValidator: TextValidatable {
    /// メールアドレスのフォーマットに沿っているか
    func isValid(_ text: String) -> Bool {
        // 未入力でないこと
        guard !text.isEmpty else { return false }
        let atSign: String = "@"
        let period: Character = "."
        let consececutivePeriods = ".."
        // @の前後に文字列が存在すること(// @が1つだけ含まれていること)
        let parts = text.components(separatedBy: atSign)
        guard parts.count == 2 else { return false }
        
        let localPart = parts[0]
        let domainPart = parts[1]
        // @の前後に文字列があること
        guard !localPart.isEmpty else { return false }
        guard !domainPart.isEmpty else { return false }
        // ドメイン部に.が含まれていること
        guard domainPart.contains(".") else { return false }
        // ドメイン部で.が連続していないこと
        guard !domainPart.contains("..") else { return false }
        // ドメイン部の先頭・末尾が . ではないこと
        guard !domainPart.hasPrefix(".") else { return false }
        guard !domainPart.hasSuffix(".") else { return false }
        return true
    }
}


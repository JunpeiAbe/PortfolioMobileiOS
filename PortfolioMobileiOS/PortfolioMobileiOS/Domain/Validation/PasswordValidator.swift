import Foundation

struct PasswordValidator: TextValidatable {
    /// パスワードのフォーマットに沿っているかどうか
    func isValid(_ text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: AllowedCharacterRegex.passwordPolicy.pattern) else { return false }
        guard regex.firstMatch(in: text, range: NSRange(0..<text.count)) != nil else {
            return false
        }
        return true
        
    }
}


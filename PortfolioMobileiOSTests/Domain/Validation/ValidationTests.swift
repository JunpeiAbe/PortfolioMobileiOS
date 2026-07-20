import Foundation
import Testing
@testable import PortfolioMobileiOS

@Suite("Validation", .serialized)
struct ValidationTests {
    struct ValidationCase: Sendable {
        let input: String
        let expected: Bool
    }

    // メールアドレスの正常系・形式不正・文字数境界をまとめて検証する。
    @Test(arguments: [
        ValidationCase(input: "a@b.co", expected: true),
        ValidationCase(input: "portfolio@example.com", expected: true),
        ValidationCase(input: "", expected: false),
        ValidationCase(input: "plain-address", expected: false),
        ValidationCase(input: "@example.com", expected: false),
        ValidationCase(input: "user@", expected: false),
        ValidationCase(input: "user@.example.com", expected: false),
        ValidationCase(input: "user@example..com", expected: false)
    ])
    func mailAddress(case value: ValidationCase) {
        #expect(MailAddressValidator().isValid(value.input) == value.expected)
    }

    // パスワードポリシーの正常系・必須文字種・8〜32文字境界をまとめて検証する。
    @Test(arguments: [
        ValidationCase(input: "Abcdef1!", expected: true),
        ValidationCase(input: "Abcdefghijklmnopqrstuvwxyz12345!", expected: true),
        ValidationCase(input: "Abc1!", expected: false),
        ValidationCase(input: "Abcdefgh!", expected: false),
        ValidationCase(input: "12345678!", expected: false),
        ValidationCase(input: "Abcdefg1", expected: false),
        ValidationCase(input: "Abcdef1+", expected: false),
        ValidationCase(input: "日本語Ab1!", expected: false)
    ])
    func password(case value: ValidationCase) {
        #expect(PasswordValidator().isValid(value.input) == value.expected)
    }
}

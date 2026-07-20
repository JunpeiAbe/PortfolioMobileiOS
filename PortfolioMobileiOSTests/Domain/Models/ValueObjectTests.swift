import Foundation
import Testing
@testable import PortfolioMobileiOS

@Suite("Value objects")
struct ValueObjectTests {
    struct VersionCase: Sendable {
        let lhs: String
        let rhs: String
        let expected: Bool
    }

    // major・minor・patchと桁数の異なるバージョン比較をまとめて検証する。
    @Test(arguments: [
        VersionCase(lhs: "1.0.0", rhs: "2.0.0", expected: true),
        VersionCase(lhs: "1.9.0", rhs: "1.10.0", expected: true),
        VersionCase(lhs: "1.0.9", rhs: "1.0.10", expected: true),
        VersionCase(lhs: "1.0", rhs: "1.0.1", expected: true),
        VersionCase(lhs: "2.0.0", rhs: "1.9.9", expected: false),
        VersionCase(lhs: "1.0.0", rhs: "1.0.0", expected: false)
    ])
    func appVersionOrdering(case value: VersionCase) {
        #expect((AppVersion(value: value.lhs) < AppVersion(value: value.rhs)) == value.expected)
    }

    // バージョン文字列の等価性を検証する。
    @Test func appVersionEquality() {
        #expect(AppVersion(value: "1.2.3") == AppVersion(value: "1.2.3"))
        #expect(AppVersion(value: "1.2") == AppVersion(value: "1.2.0"))
    }

    // LoadingStateがloadingのときだけisLoadingをtrueにすることを検証する。
    @Test(arguments: [LoadingState.idle, .loading, .loaded, .failed("error")])
    func loadingState(_ state: LoadingState) {
        #expect(state.isLoading == (state == .loading))
    }

    // ISO 8601文字列がJSTの表示文字列へ変換されることを検証する。
    @Test func iso8601ToJST() {
        #expect("2026-06-13T10:00:00Z".iso8601ToJSTString() == "2026/06/13 19:00")
    }

    // 不正な日付文字列では元の文字列を返すことを検証する。
    @Test func invalidISO8601() {
        #expect("not-a-date".iso8601ToJSTString() == "not-a-date")
    }

    // タブごとの表示タイトルをまとめて検証する。
    @Test(arguments: [
        (SelectableTab.home, "Home"), (.features, "Features"), (.design, "Design"),
        (.menu, "Menu"), (.notification, "Notification"), (.history, "History"), (.setting, "Setting")
    ])
    func selectableTabTitle(tab: SelectableTab, expected: String) {
        #expect(tab.title == expected)
    }
}

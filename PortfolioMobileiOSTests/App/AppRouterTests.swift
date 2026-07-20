import Foundation
import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("AppRouter", .serialized)
struct AppRouterTests {
    // push・pop・popToRootによるNavigation履歴の変化を検証する。
    @Test func navigationHistory() {
        let router = DefaultAppRouter()
        router.push(.login)
        router.push(.main)
        router.push(.featureDetail(TestFixtures.feature()))
        router.pop(.main)
        #expect(router.pushDestinations == [.login, .main])
        router.pop()
        #expect(router.pushDestinations == [.login])
        router.popToRoot()
        #expect(router.pushDestinations.isEmpty)
        router.pop()
        #expect(router.pushDestinations.isEmpty)
    }

    // Loading表示のON・OFFを検証する。
    @Test func loading() {
        let router = DefaultAppRouter()
        router.showLoading()
        #expect(router.isLoading)
        router.hideLoading()
        #expect(!router.isLoading)
    }

    // enqueue・drop・replaceの各Alert policyを検証する。
    @Test func alertPolicies() {
        let router = DefaultAppRouter()
        let first = PresentAlert(title: "first", message: "", actions: [], policy: .enqueue)
        let queued = PresentAlert(title: "queued", message: "", actions: [], policy: .enqueue)
        let dropped = PresentAlert(title: "dropped", message: "", actions: [], policy: .dropIfPresenting)
        let replacement = PresentAlert(title: "replacement", message: "", actions: [], policy: .replaceCurrent)
        router.showAlert(first)
        router.showAlert(queued)
        router.showAlert(dropped)
        #expect(router.presentedAlert?.title == "first")
        #expect(router.alertQueue.count == 1)
        router.showAlert(replacement)
        #expect(router.presentedAlert?.title == "replacement")
        router.dismissAllAlerts()
        #expect(router.presentedAlert == nil)
        #expect(router.alertQueue.isEmpty)
    }
}

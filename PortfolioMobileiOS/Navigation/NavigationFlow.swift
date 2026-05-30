import SwiftUI

@Observable
@MainActor
final class NavigationFlow {
    /// push遷移する画面履歴
    var pushDestinations: [PushDestination] = []
    weak var parentFlow: NavigationFlow?

    init(
        parentFlow: NavigationFlow? = nil
    ) {
        self.parentFlow = parentFlow
    }
    
    /// 一画面先に遷移
    func push(_ destination: PushDestination) {
        pushDestinations.append(destination)
    }
    /// 指定画面に戻る
    func pop(_ destination: PushDestination) {
        for _ in pushDestinations {
            if pushDestinations.contains(destination) {
                pushDestinations.removeLast()
            }
        }
    }
    /// ルート画面に戻る
    func popToRoot() {
        pushDestinations = []
    }
}

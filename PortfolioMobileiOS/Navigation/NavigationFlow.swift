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
        print("pushDestinations:", pushDestinations)
    }
    /// 一画面前に戻る
    func pop() {
        if !pushDestinations.isEmpty {
            pushDestinations.removeLast()
        }
    }
    /// 指定画面に戻る
    func pop(_ destination: PushDestination) {
        while let last = pushDestinations.last {
            pushDestinations.removeLast()
            if last == destination {
                break
            }
        }
    }
    /// ルート画面に戻る
    func popToRoot() {
        pushDestinations = []
    }
}

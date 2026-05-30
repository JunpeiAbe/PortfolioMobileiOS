import Foundation
import SwiftUI

struct NavigationFlowContainer<RootScreen: View>: View {
    let flow: NavigationFlow
    let rootScreen: () -> RootScreen
    let pushDestinationBuilder: (PushDestination) -> any View
    
    init(
        flow: NavigationFlow,
        rootScreen: @escaping () -> RootScreen,
        pushDestinationBuilder: @escaping (PushDestination) -> any View,
    ) {
        self.flow = flow
        self.rootScreen = rootScreen
        self.pushDestinationBuilder = pushDestinationBuilder
    }
    
    var body: some View {
        @Bindable var flow = flow
        NavigationStack(path: $flow.pushDestinations) {
            rootScreen()
                .navigationDestination(for: PushDestination.self) { destination in
                    AnyView(pushDestinationBuilder(destination))
                }
        }
        .environment(flow)
    }
}

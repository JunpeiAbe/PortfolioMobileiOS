import Foundation
import SwiftUI

struct NavigationFlowContainer<
    RootScreen: View,
    DestinationScreen: View
>: View {
    /*
     @ViewBuilderを採用する理由:
     - 呼び出し側で `NavigationFlowContainer { RootView() }` のようにSwiftUIらしいDSLで書ける。
     - `if` / `switch` などの条件分岐を含むView生成を自然に扱える。
     - `pushDestination` でも、PushDestinationごとに異なる画面をswitchで返しやすくなる。
     - 呼び出し側で `AnyView` に包む必要を減らせる。

     Genericsを採用する理由:
     - `RootScreen` と `DestinationScreen` の具体的なView型をコンパイル時に保持できる。
     - `any View` や `AnyView` による型消去を避けやすい。
     - SwiftUIがView階層の型情報を保てるため、型安全でSwiftUIらしい実装になる。
     - root画面とpush遷移先画面を差し替え可能にしつつ、Container自体の再利用性を保てる。
     */
    private let flow: NavigationFlow
    private let rootScreen: () -> RootScreen
    private let pushDestination: (PushDestination) -> DestinationScreen
    @State var isLoading: Bool = false
    
    init(
        flow: NavigationFlow,
        @ViewBuilder rootScreen: @escaping () -> RootScreen,
        @ViewBuilder pushDestination: @escaping (PushDestination) -> DestinationScreen,
    ) {
        self.flow = flow
        self.rootScreen = rootScreen
        self.pushDestination = pushDestination
    }
    
    var body: some View {
        @Bindable var bindableFlow = flow

        NavigationStack(path: $bindableFlow.pushDestinations) {
            rootScreen()
                .navigationDestination(for: PushDestination.self) { destination in
                    pushDestination(destination)
                }
        }
        .alert(
            flow.presentedAlert?.title ?? .init(),
            isPresented: .init(
                get: { flow.presentedAlert != nil },
                set: { _ in flow.presentedAlert = nil }
            ),
            presenting: flow.presentedAlert,
            actions: { alert in
                ForEach(alert.actions) { action in
                    Button(action.title, role: action.role) {
                        flow.dismissAlert()
                        action.action()
                    }
                }
            },
            message: { alert in
                Text(alert.message)
            }
        )
        .loading(
            isPresented: $isLoading
        )
        .environment(\.loading, .init(
            show: {
                isLoading = true
            },
            hide: {
                isLoading = false
            }
        ))
        .environment(flow)
    }
}

import SwiftUI

struct RootScreen: View {
    private let screenBuilder: ScreensBuilder = .init()
    @State private var appRouter: AppRouter = .init()
    var body: some View {
        @Bindable var bindableAppRouter = appRouter
        NavigationFlowContainer(
            flow: bindableAppRouter.mainNavigationFlow,
            rootScreen: { LoginScreen(state: .init()) },
            pushDestination: screenBuilder.pushDestination
        )
    }
}

#Preview {
    RootScreen()
}

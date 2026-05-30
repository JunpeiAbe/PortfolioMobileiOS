import SwiftUI

struct RootScreen: View {
    private let screenBuilder: ScreensBuilder = .init()
    @State private var appRouter: AppRouter = .init()
    var body: some View {
        @Bindable var appRouter = appRouter
        NavigationFlowContainer(
            flow: appRouter.mainNavigationFlow,
            rootScreen: { LoginScreen(state: .init()) },
            pushDestinationBuilder: screenBuilder.pushDestination
        )
    }
}

#Preview {
    RootScreen()
}

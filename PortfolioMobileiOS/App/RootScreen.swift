import SwiftUI

struct RootScreen: View {
    private let screenBuilder: ScreensBuilder
    @State private var appRouter: AppRouter = .init()
    
    init(dependency: AppDependency) {
        screenBuilder = ScreensBuilder(dependency: dependency)
    }
    
    var body: some View {
        @Bindable var bindableAppRouter = appRouter
        NavigationFlowContainer(
            flow: bindableAppRouter.mainNavigationFlow,
            rootScreen: { screenBuilder.rootScreen() },
            pushDestination: screenBuilder.pushDestination
        )
    }
}

#Preview {
    RootScreen(dependency: AppDependency.debug)
}

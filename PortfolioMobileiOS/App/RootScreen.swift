import SwiftUI

struct RootScreen: View {
    private let screenBuilder: ScreensBuilder
    @State private var appRouter: AppRouter = .init()
    
    init(dependency: AppDependency) {
        screenBuilder = ScreensBuilder(dependency: dependency)
    }
    
    var body: some View {
        @Bindable var bindableAppRouter = appRouter
        TabView(selection: $bindableAppRouter.selectedTab) {
            Tab(SelectableTab.home.title, systemImage: "house", value: .home) {
                NavigationFlowContainer(
                    flow: bindableAppRouter.homeNavigationFlow,
                    rootScreen: { screenBuilder.homeRootScreen() },
                    pushDestination: screenBuilder.pushDestination
                )
            }
            Tab(SelectableTab.menu.title, systemImage: "list.bullet", value: .menu) {
                NavigationFlowContainer(
                    flow: bindableAppRouter.menuNavigationFlow,
                    rootScreen: { screenBuilder.menuRootScreen() },
                    pushDestination: screenBuilder.pushDestination
                )
            }
            Tab(SelectableTab.history.title, systemImage: "clock.arrow.circlepath", value: .history) {
                NavigationFlowContainer(
                    flow: bindableAppRouter.historyNavigationFlow,
                    rootScreen: { screenBuilder.historyRootScreen() },
                    pushDestination: screenBuilder.pushDestination
                )
            }
            Tab(SelectableTab.notification.title, systemImage: "bell", value: .notification) {
                NavigationFlowContainer(
                    flow: bindableAppRouter.notificationsNavigationFlow,
                    rootScreen: { screenBuilder.notificationRootScreen() },
                    pushDestination: screenBuilder.pushDestination
                )
            }
            Tab(SelectableTab.setting.title, systemImage: "gearshape", value: .setting) {
                NavigationFlowContainer(
                    flow: bindableAppRouter.settignsNavigationFlow,
                    rootScreen: { screenBuilder.settingRootScreen() },
                    pushDestination: screenBuilder.pushDestination
                )
            }
        }
//        NavigationFlowContainer(
//            flow: bindableAppRouter.mainNavigationFlow,
//            rootScreen: { screenBuilder.rootScreen() },
//            pushDestination: screenBuilder.pushDestination
//        )
    }
}

#Preview {
    RootScreen(dependency: AppDependency.debug)
}

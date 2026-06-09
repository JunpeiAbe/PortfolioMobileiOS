import SwiftUI

struct MainScreen: View {
    
    private let screenBuilder: ScreensBuilder
    private let appRouter: AppRouter
    init(
        screenBuilder: ScreensBuilder,
        appRouter: AppRouter
    ) {
        self.screenBuilder = screenBuilder
        self.appRouter = appRouter
    }
    
    var body: some View {
        EmptyView()
//        @Bindable var bindableAppRouter = appRouter
//        TabView(selection: $bindableAppRouter.selectedTab) {
//            Tab(SelectableTab.home.title, systemImage: "house", value: .home) {
//                screenBuilder.homeRootScreen()
//            }
//            Tab(SelectableTab.menu.title, systemImage: "list.bullet", value: .menu) {
//                screenBuilder.menuRootScreen()
//            }
//            Tab(SelectableTab.history.title, systemImage: "clock.arrow.circlepath", value: .history) {
//               screenBuilder.historyRootScreen()
//            }
//            Tab(SelectableTab.notification.title, systemImage: "bell", value: .notification) {
//                screenBuilder.notificationRootScreen()
//            }
//            Tab(SelectableTab.setting.title, systemImage: "gearshape", value: .setting) {
//                screenBuilder.settingRootScreen()
//            }
//        }
    }
}

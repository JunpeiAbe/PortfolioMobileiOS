import SwiftUI

struct MainScreen: View {
    
    private let screenBuilder: ScreensBuilder
    @State private var state: MainScreenState
    init(
        dependency: AppDependency
    ) {
        self._state = State(
            initialValue: dependency.makeMainState()
        )
        self.screenBuilder = ScreensBuilder(
            dependency: dependency
        )
    }
    
    var body: some View {
        TabView(selection: $state.appRouter.selectedTab) {
            Tab(
                SelectableTab.home.title,
                systemImage: "house",
                value: .home
            ) {
                screenBuilder.homeRootScreen()
            }
            Tab(
                SelectableTab.menu.title,
                systemImage: "list.bullet",
                value: .menu
            ) {
                screenBuilder.menuRootScreen()
            }
            Tab(
                SelectableTab.history.title,
                systemImage: "clock.arrow.circlepath",
                value: .history
            ) {
                screenBuilder
                    .historyRootScreen()
            }
            Tab(
                SelectableTab.notification.title,
                systemImage: "bell",
                value: .notification
            ) {
                screenBuilder
                    .notificationRootScreen()
            }
            Tab(
                SelectableTab.setting.title,
                systemImage: "gearshape",
                value: .setting
            ) {
                screenBuilder
                    .settingRootScreen()
            }
        }
    }
}

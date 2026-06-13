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
                SelectableTab.notification.title,
                systemImage: "bell",
                value: .notification
            ) {
                screenBuilder
                    .notificationRootScreen()
            }
        }
        .toolBar(
            title: state.appRouter.selectedTab.title,
            isLeftButtonHidden: true,
            leftButtonAction: {},
            logoutButtonAction: {
                state.logoutButtonPressed()
            },
            helpButtonAction: {}
        )
    }
}

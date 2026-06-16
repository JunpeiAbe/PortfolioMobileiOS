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
                SelectableTab.features.title,
                systemImage: "square.grid.2x2",
                value: .features
            ) {
                screenBuilder
                    .featuresScreen()
            }
            Tab(
                SelectableTab.design.title,
                systemImage: "paintpalette",
                value: .design
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

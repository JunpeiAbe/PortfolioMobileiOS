import SwiftUI

struct HomeScreen: View {
    @State var state: HomeScreenState
    @Environment(AppRouter.self) private var appRouter
    @Environment(\.loading) var loading
    init(state: HomeScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Button("Show Alert") {
                appRouter
                    .showAlert(
                        .init(
                            title: AlertContent.sample.title,
                            message: AlertContent.sample.message,
                            actions: AlertContent.sample.actions
                        )
                    )
                appRouter
                    .showAlert(
                        .init(
                            title: "2つ目のアラート",
                            message: AlertContent.sample.message,
                            actions: AlertContent.sample.actions
                        )
                    )
                appRouter
                    .showAlert(
                        .init(
                            title: "3つ目のアラート",
                            message: AlertContent.sample.message,
                            actions: AlertContent.sample.actions
                        )
                    )
            }
            .buttonStyle(
                .filled(
                    backgroundColor: Color.main
                )
            )
            .headlineFont()
            .frame(height: 48)
        }
        .screenBackground()
        .toolBar(
            title: "Home",
            isLeftButtonHidden: true,
            leftButtonAction: {},
            rightButtonAction: {})
        .onChange(of: state.loadingState.isLoading) { _, newValue in
            if newValue {
                loading.show()
            } else {
                loading.hide()
            }
        }
    }
}

#Preview {
    @Previewable var state: HomeScreenState = .init()
    HomeScreen(state: state)
}

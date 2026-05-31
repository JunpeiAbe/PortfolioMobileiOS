import SwiftUI

struct HomeScreen: View {
    @State var state: HomeScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: HomeScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Button("Show Alert") {
                navigationFlow
                    .showAlert(
                        .init(
                            title: AlertContent.sample.title,
                            message: AlertContent.sample.message,
                            actions: AlertContent.sample.actions
                        )
                    )
                navigationFlow
                    .showAlert(
                        .init(
                            title: "2つ目のアラート",
                            message: AlertContent.sample.message,
                            actions: AlertContent.sample.actions
                        )
                    )
                navigationFlow
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
    }
}

#Preview {
    @Previewable var state: HomeScreenState = .init()
    HomeScreen(state: state)
}

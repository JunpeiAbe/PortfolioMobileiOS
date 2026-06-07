import SwiftUI

struct SplashScreen: View {
    
    @State var state: SplashScreenState
    @Environment(AppRouter.self) private var appRouter
    @Environment(\.loading) var loading
    init(state: SplashScreenState) {
        self.state = state
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            Image(.appIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        .screenBackground()
        .taskOnce {
            appRouter.appScene = await state.onAppear()
        }
        .onChange(of: state.alertContent) { _, newContent in
            if let newContent {
                appRouter.showAlert(newContent)
            }
        }
    }
}

#Preview {
    @Previewable var state: SplashScreenState = AppDependency.debug().makeSplashState()
    SplashScreen(state: state)
}

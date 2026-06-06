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
        .onAppear {
            appRouter.showMain()
        }
    }
}

#Preview {
    @Previewable var state: SplashScreenState = .init()
    SplashScreen(state: state)
}

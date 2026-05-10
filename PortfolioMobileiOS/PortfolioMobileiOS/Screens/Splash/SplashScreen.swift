import SwiftUI

struct SplashScreen: View {
    
    @State var state: SplashScreenState
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
    }
}

#Preview {
    @Previewable var state: SplashScreenState = .init()
    SplashScreen(state: state)
}

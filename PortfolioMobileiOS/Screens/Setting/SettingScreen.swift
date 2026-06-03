import SwiftUI

struct SettingScreen: View {
    @State var state: SettingScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: SettingScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Color.blue
        }
    }
}

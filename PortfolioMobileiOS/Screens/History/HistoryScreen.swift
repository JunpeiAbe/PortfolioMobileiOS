import SwiftUI

struct HistoryScreen: View {
    @State var state: HistoryScreenState
    @Environment(NavigationFlow.self) private var navigationFlow
    init(state: HistoryScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Color.blue
        }
    }
}

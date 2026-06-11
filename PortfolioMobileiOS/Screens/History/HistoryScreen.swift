import SwiftUI

struct HistoryScreen: View {
    @State var state: HistoryScreenState
    init(state: HistoryScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            EmptyView()
        }
        .screenBackground()
    }
}

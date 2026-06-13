import SwiftUI

struct NotificationScreen: View {
    @State var state: NotificationScreenState
    init(state: NotificationScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(state.notices) { notice in
                        NotificationRow(notice: notice)
                    }
                }
                .padding(16)
            }
        }
        .screenBackground()
        .refreshable {
            await state.refreshNotices()
        }
        .taskOnce {
            await state.onAppear()
        }
    }
}

#Preview {
    NotificationScreen(state: AppDependency.debug().makeNotificationState())
}

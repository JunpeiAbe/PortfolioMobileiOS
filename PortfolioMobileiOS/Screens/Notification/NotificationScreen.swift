import SwiftUI

struct NotificationScreen: View {
    @State var state: NotificationScreenState
    @Environment(\.loading) var loading
    init(state: NotificationScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            if !state.isNoticesEmpty {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(state.notices) { notice in
                            NotificationRow(notice: notice)
                                .task {
                                    await state.loadMoreIfNeeded(currentNotice: notice)
                                }
                        }
                    }
                    .padding(16)
                }
            } else {
                emptyContent()
            }
        }
        .screenBackground()
        
        .refreshable {
            await state.refreshNotices()
        }
        .taskOnce {
            await state.onAppear()
        }
        .onChange(of: state.loadingState.isLoading) { _, newValue in
            if newValue {
                loading.show()
            } else {
                loading.hide()
            }
        }
    }
    
    private struct emptyContent: View {
        var body: some View {
            Image(systemName: "bell")
                .font(.system(size: 60))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    NotificationScreen(state: AppDependency.debug().makeNotificationState())
}

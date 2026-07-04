import Foundation

@MainActor
@Observable
final class DefaultPushNotificationStore: PushNotificationStore {
    
    private let pushNotificationRepository: PushNotificationRepository
    
    init(pushNotificationRepository: PushNotificationRepository) {
        self.pushNotificationRepository = pushNotificationRepository
    }
    
    func requestAuthorization() async {
        await pushNotificationRepository.requestAuthorization()
    }
}

import Foundation

struct DefaultPushNotificationRepository: PushNotificationRepository {
    private let pushNotificationClient: PushNotificationClient
    
    init(pushNotificationClient: PushNotificationClient) {
        self.pushNotificationClient = pushNotificationClient
    }
    
    func requestAuthorization() async {
        await pushNotificationClient.requestAuthorization()
    }
}

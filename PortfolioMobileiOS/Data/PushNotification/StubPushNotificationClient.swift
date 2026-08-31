import UIKit
import UserNotifications

struct StubPushNotificationClient: PushNotificationClient {
    func requestAuthorization() async {}

    func fetchFCMToken() async throws -> String {
        return .init()
    }
}


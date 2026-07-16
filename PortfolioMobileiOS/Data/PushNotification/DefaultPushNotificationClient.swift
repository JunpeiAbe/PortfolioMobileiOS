import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

struct DefaultPushNotificationClient: PushNotificationClient {
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            guard granted else {
                return
            }
            await UIApplication.shared.registerForRemoteNotifications()
        } catch {
        }
    }

    func fetchFCMToken() async throws -> String {
        try await Messaging.messaging().token()
    }
}

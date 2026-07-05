import UIKit
import UserNotifications
import FirebaseMessaging

struct DefaultPushNotificationClient: PushNotificationClient {
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            guard granted else {
                print("Push notification permission denied")
                return
            }
            await UIApplication.shared.registerForRemoteNotifications()
        } catch {
            print(error)
        }
    }

    func fetchFCMToken() async throws -> String {
        try await Messaging.messaging().token()
    }
}

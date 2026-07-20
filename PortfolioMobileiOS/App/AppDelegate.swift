import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

final class AppDelegate: NSObject {}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
#if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-screenshot-screen")
            || ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return true
        }
#endif
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification
    ) async -> UNNotificationPresentationOptions {
        // アプリ起動中に通知を表示したい場合
        [.banner, .sound, .badge]
    }
}

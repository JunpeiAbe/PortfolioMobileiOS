import Foundation

@MainActor
protocol PushNotificationStore {
    func requestAuthorization() async
}

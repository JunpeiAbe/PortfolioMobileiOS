import Foundation

protocol PushNotificationClient: Sendable {
    func requestAuthorization() async
}

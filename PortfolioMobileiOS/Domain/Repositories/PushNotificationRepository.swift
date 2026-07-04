import Foundation

protocol PushNotificationRepository: Sendable {
    func requestAuthorization() async
}

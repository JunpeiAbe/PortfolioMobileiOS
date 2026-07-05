import Foundation

protocol PushNotificationRepository: Sendable {
    func requestAuthorization() async
    func registerToken(deviceID: String) async throws
}

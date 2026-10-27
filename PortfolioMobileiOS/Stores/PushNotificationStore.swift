import Foundation

@MainActor
protocol PushNotificationStore: Sendable {
    func requestAuthorization() async
    func registerToken(deviceID: String) async throws
}

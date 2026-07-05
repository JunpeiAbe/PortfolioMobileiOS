import Foundation

@MainActor
protocol PushNotificationStore {
    func requestAuthorization() async
    func registerToken(deviceID: String) async throws
}

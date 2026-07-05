import Foundation

protocol PushNotificationClient: Sendable {
    func requestAuthorization() async
    func fetchFCMToken() async throws -> String
}

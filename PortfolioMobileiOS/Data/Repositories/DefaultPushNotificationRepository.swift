import Foundation

struct DefaultPushNotificationRepository: PushNotificationRepository {
    private let pushNotificationClient: PushNotificationClient
    private let apiClient: APIClient
    
    init(
        pushNotificationClient: PushNotificationClient,
        apiClient: APIClient
    ) {
        self.pushNotificationClient = pushNotificationClient
        self.apiClient = apiClient
    }
    
    func requestAuthorization() async {
        await pushNotificationClient.requestAuthorization()
    }

    func registerToken(deviceID: String) async throws {
        let token = try await pushNotificationClient.fetchFCMToken()
        let response = try await apiClient.send(
            RegisterPushTokenRequest(
                httpBody: .init(
                    token: token,
                    platform: "ios",
                    deviceID: deviceID
                )
            )
        )
        if let error = response.error {
            throw error
        }
    }
}

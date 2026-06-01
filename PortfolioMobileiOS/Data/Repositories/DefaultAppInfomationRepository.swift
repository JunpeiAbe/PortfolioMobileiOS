import Foundation

struct DefaultAppInfomationRepository: AppInfomationRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchAppInfomation() async throws -> AppInfomation {
        let response = try await apiClient.send(AppInformationRequest())
        if let error = response.error {
            throw error
        }
        return AppInfomation(
            isMaintenance: response.isMaintenance,
            iOSMinAppVersion: response.iOSMinAppVersion,
            appTermURL: response.appTermURL,
            appTermVersion: response.appTermVersion,
            qaURL: response.qaURL
        )
    }
}

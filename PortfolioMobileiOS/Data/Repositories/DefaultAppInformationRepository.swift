import Foundation

struct DefaultAppInformationRepository: AppInformationRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchAppInformation() async throws -> AppInformation {
        let response = try await apiClient.send(AppInformationRequest())
        if let error = response.error {
            throw error
        }
        return AppInformation(
            isMaintenance: response.isMaintenance,
            iOSMinAppVersion: response.iOSMinAppVersion,
            appTermURL: response.appTermURL,
            appTermVersion: response.appTermVersion,
            qaURL: response.qaURL
        )
    }
}

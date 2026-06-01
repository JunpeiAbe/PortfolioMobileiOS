import Foundation
@MainActor
@Observable
final class DefaultAppInfomationStore: AppInfomationStore {
    private let appInfomationRepository: AppInfomationRepository
    private(set) var appInfomation: AppInfomation?
    
    init(appInfomationRepository: AppInfomationRepository) {
        self.appInfomationRepository = appInfomationRepository
    }
    
    func fetchAppInfomation() async throws {
        let infomation = try await appInfomationRepository.fetchAppInfomation()
        appInfomation = infomation
    }
}

import Foundation

protocol AppInfomationRepository {
    func fetchAppInfomation() async throws -> AppInfomation
}

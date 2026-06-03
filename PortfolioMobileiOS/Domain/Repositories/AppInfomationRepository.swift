import Foundation

protocol AppInfomationRepository: Sendable {
    func fetchAppInfomation() async throws -> AppInfomation
}

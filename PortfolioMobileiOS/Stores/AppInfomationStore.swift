import Foundation

@MainActor
protocol AppInfomationStore {
    var appInfomation: AppInfomation? { get }
    func fetchAppInfomation() async throws
}

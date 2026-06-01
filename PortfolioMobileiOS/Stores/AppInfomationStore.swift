import Foundation

protocol AppInfomationStore {
    var appInfomation: AppInfomation? { get }
    func fetchAppInfomation() async throws
}

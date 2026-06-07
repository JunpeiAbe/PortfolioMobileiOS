import Foundation
@MainActor
@Observable
final class DefaultAppInfomationStore: AppInfomationStore {
    private let appInfomationRepository: AppInfomationRepository
    private(set) var appInfomation: AppInfomation?
    /// 現在のアプリバージョン
    var currentAppVersion: AppVersion? {
        guard let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String else {
            return nil
        }
        return AppVersion(value: version)
    }
    /// 最新のアプリバージョン
    var latestAppVersion: AppVersion? {
        guard let version = appInfomation?.iOSMinAppVersion else {
            return nil
        }
        return AppVersion(value: version)
    }
    /// アップデート必要かどうか
    var needsForceUpdate: Bool {
        guard let currentAppVersion,
              let latestAppVersion else {
            return false
        }
        return currentAppVersion < latestAppVersion
    }
    /// メンテナンス中かどうか
    var isMaintenance: Bool {
        guard let isMaintenance = appInfomation?.isMaintenance else {
            return false
        }
        return isMaintenance
    }
    
    init(appInfomationRepository: AppInfomationRepository) {
        self.appInfomationRepository = appInfomationRepository
    }
    
    func fetchAppInfomation() async throws {
        let infomation = try await appInfomationRepository.fetchAppInfomation()
        appInfomation = infomation
    }
}

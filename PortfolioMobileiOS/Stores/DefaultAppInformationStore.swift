import Foundation

@MainActor
@Observable
final class DefaultAppInformationStore: AppInformationStore {
    private let appInformationRepository: AppInformationRepository
    private(set) var appInformation: AppInformation?
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
        guard let version = appInformation?.iOSMinAppVersion else {
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
        guard let isMaintenance = appInformation?.isMaintenance else {
            return false
        }
        return isMaintenance
    }
    
    init(appInformationRepository: AppInformationRepository) {
        self.appInformationRepository = appInformationRepository
    }
    
    func fetchAppInformation() async throws {
        let information = try await appInformationRepository.fetchAppInformation()
        appInformation = information
    }
}

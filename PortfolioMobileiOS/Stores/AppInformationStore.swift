import Foundation

@MainActor
protocol AppInformationStore {
    var appInformation: AppInformation? { get }
    func fetchAppInformation() async throws
    /// 現在のアプリバージョン
    var currentAppVersion: AppVersion? { get }
    /// 最新のアプリバージョン
    var latestAppVersion: AppVersion? { get }
    /// アップデート必要かどうか
    var needsForceUpdate: Bool { get }
    /// メンテナンス中かどうか
    var isMaintenance: Bool { get }
}

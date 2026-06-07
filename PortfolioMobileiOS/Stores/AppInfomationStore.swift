import Foundation

@MainActor
protocol AppInfomationStore {
    var appInfomation: AppInfomation? { get }
    func fetchAppInfomation() async throws
    /// 現在のアプリバージョン
    var currentAppVersion: AppVersion? { get }
    /// 最新のアプリバージョン
    var latestAppVersion: AppVersion? { get }
    /// アップデート必要かどうか
    var needsForceUpdate: Bool { get }
    /// メンテナンス中かどうか
    var isMaintenance: Bool { get }
}

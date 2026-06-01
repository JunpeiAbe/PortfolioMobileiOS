import Foundation

enum APIClientError: Error, Equatable {
    /// urlリクエスト生成失敗
    case requestBuildFailed
    /// 不正なレスポンス(200番台以外)
    case invalidResponse(_ statusCode: Int)
    /// エンコード失敗
    case encodingFailed
    /// デコード失敗
    case decodingFailed
    /// ネットワーク接続失敗
    case notConnectedToInternet
    /// 不明
    case unknown
}

import Foundation

enum APIClientError: Error, Equatable {
    /// トークン取得失敗
    case getAccessTokenFailed
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

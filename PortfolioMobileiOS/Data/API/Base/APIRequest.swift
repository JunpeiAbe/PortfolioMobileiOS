import Foundation

protocol APIRequest {
    associatedtype Response: APIResponse
    associatedtype Body: Encodable
    /// エンドポイント
    var path: String { get }
    /// httpメソッド
    var httpMethod: HttpMethod { get }
    /// 個別ヘッダーフィールド
    var httpHeaderFields: [String : String] { get }
    /// 認証が必要かどうか
    var requiresAuthorization: Bool { get }
    /// httpボディ
    var httpBody: Body? { get }
    /// クエリ
    var queryItems: [URLQueryItem] { get }
}

extension APIRequest {
    var queryItems: [URLQueryItem] {
        []
    }
}

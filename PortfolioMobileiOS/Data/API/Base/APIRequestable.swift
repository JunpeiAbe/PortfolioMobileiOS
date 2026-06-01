import Foundation

protocol APIRequestable: Encodable {
    associatedtype Response: APIResponsable
    associatedtype HttpBody: Codable
    /// ベースURL
    var baseURL: String { get }
    /// エンドポイント
    var path: String { get set }
    /// httpメソッド
    var httpMethod: HttpMethod { get set }
    /// httpヘッダーフィールド
    var httpHeaderFields: [String : String] { get }
    /// アクセストークン
    var accessToken: String { get }
    /// httpボディ
    var httpBody: HttpBody? { get set }
}

extension APIRequestable {
    var baseURL: String {
        return .init()
    }
    var httpHeaderFields: [String : String] {
        return [
            "Content-Type" : "application/json",
            "Authorization": "Bearer \(self.accessToken)"
        ]
    }
    /// URLリクエスト生成
    func makeURLRequest() async throws -> URLRequest {
        guard let url = URL(string: baseURL.appending(path)) else {
            throw APIClientError.requestBuildFailed
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = httpHeaderFields
        if let httpBody {
            do {
                let data = try JSONEncoder().encode(httpBody)
                request.httpBody = data
            } catch {
                throw APIClientError.encodingFailed
            }
        }
        return request
    }
}

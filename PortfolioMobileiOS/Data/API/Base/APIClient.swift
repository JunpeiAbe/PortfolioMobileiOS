import Foundation

protocol APIClient {
    var session: URLSession { get set }
    func send<Request: APIRequestable>(_ request: Request) async throws -> Request.Response
}

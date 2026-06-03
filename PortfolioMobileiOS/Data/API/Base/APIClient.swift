import Foundation

protocol APIClient: Sendable {
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}

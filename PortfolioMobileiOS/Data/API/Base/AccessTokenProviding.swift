import Foundation

protocol AccessTokenProviding: Sendable {
    func getAccessToken() async throws -> String?
}

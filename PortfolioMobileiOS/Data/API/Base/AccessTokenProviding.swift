import Foundation

protocol AccessTokenProviding {
    func getAccessToken() async throws -> String?
}


import Foundation

protocol AgreeTermRepository: Sendable {
    func agreeTerm(termsVersion: String) async throws
}

import Foundation

protocol AgreeTermRepository: Sendable {
    func agreeTerm(mailAddress: String, termsVersion: String) async throws
}

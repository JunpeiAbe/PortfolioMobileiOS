import Foundation

protocol AgreeTermRepository {
    func agreeTerm(mailAddress: String, termsVersion: String) async throws
}

import Foundation

struct DefaultAgreeTermRepository: AgreeTermRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func agreeTerm(mailAddress: String, termsVersion: String) async throws {
        let response = try await apiClient.send(AgreeTermRequest(httpBody: .init(mailAddress: mailAddress, termsVersion: termsVersion)))
        if let error = response.error {
            throw error
        }
    }
}


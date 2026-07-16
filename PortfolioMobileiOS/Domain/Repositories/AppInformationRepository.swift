import Foundation

protocol AppInformationRepository: Sendable {
    func fetchAppInformation() async throws -> AppInformation
}

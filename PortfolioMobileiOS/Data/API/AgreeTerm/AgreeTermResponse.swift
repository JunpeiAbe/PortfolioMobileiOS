import Foundation

struct AgreeTermResponse: Codable {
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case error
    }
}

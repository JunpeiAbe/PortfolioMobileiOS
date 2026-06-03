import Foundation

struct AgreeTermResponse: APIResponse {
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case error
    }
}

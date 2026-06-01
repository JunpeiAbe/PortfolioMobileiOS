import Foundation

struct AgreeTermResponse: @MainActor APIResponse {
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case error
    }
}

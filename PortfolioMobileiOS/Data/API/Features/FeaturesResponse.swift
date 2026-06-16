import Foundation

struct FeaturesResponse: APIResponse {
    let items: [Feature]
    let nextCursor: String?
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case nextCursor = "next_cursor"
        case error
    }
}

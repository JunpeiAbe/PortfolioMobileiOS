import Foundation

struct NoticesResponse: APIResponse {
    let items: [Notice]
    let nextCursor: String?
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case nextCursor = "next_cursor"
        case error
    }
}

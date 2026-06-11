import Foundation

struct NoticesRequest: APIRequest {
    
    typealias Response = NoticesResponse
    
    typealias HttpBody = EmptyBody
    
    let limit: Int
    
    let cursor: String?
    
    var path: String = "notices"
    
    var httpMethod: HttpMethod = .get
    
    var httpBody: EmptyBody?
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = true
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            .init(name: "limit", value: String(limit))
        ]
        if let cursor {
            items.append(
                .init(name: "cursor", value: cursor)
            )
        }
        return items
    }
}

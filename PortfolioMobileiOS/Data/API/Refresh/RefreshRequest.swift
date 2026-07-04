import Foundation

struct RefreshRequest: APIRequest {
    typealias Response = RefreshResponse
    
    typealias HttpBody = RefreshRequestBody
    
    var path: String = "auth/refresh"
    
    var httpMethod: HttpMethod = .post
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = false
    
    var httpBody: RefreshRequestBody?
    
    init(
        httpBody: RefreshRequestBody
    ) {
        self.httpBody = httpBody
    }
}

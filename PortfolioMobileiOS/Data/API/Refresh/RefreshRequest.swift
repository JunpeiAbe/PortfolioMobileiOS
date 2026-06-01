import Foundation

struct RefreshRequest: @MainActor APIRequest {
    typealias Response = RefreshResponse
    
    typealias HttpBody = RefreshRequestBody
    
    var path: String = "refresh"
    
    var httpMethod: HttpMethod = .post
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = true
    
    var httpBody: RefreshRequestBody?
    
    init(
        httpBody: RefreshRequestBody
    ) {
        self.httpBody = httpBody
    }
}

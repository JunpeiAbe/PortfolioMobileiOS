import Foundation

struct AgreeTermRequest: @MainActor APIRequest {
    typealias Response = AgreeTermResponse
    
    typealias HttpBody = AgreeTermRequestBody
    
    var path: String = "/term"
    
    var httpMethod: HttpMethod = .post
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = false
    
    var httpBody: AgreeTermRequestBody?
    
    init(
        httpBody: AgreeTermRequestBody
    ) {
        self.httpBody = httpBody
    }
}

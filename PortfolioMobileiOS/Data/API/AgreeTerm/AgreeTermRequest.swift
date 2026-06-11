import Foundation

struct AgreeTermRequest: APIRequest {
    typealias Response = AgreeTermResponse
    
    typealias HttpBody = AgreeTermRequestBody
    
    var path: String = "term"
    
    var httpMethod: HttpMethod = .post
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = true
    
    var httpBody: AgreeTermRequestBody?
    
    init(
        httpBody: AgreeTermRequestBody
    ) {
        self.httpBody = httpBody
    }
}

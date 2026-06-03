import Foundation

struct LoginRequest: APIRequest {
    typealias Response = LoginResponse
    
    typealias HttpBody = LoginRequestBody
    
    var path: String = "/login"
    
    var httpMethod: HttpMethod = .post
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = false
    
    var httpBody: LoginRequestBody?
    
    init(
        httpBody: LoginRequestBody
    ) {
        self.httpBody = httpBody
    }
}

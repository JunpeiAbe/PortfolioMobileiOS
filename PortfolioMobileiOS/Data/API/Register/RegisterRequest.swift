import Foundation

struct RegisterRequest: APIRequest {
    typealias Response = RegisterResponse
    
    typealias HttpBody = RegisterRequestBody
    
    var path: String = "auth/register"
    
    var httpMethod: HttpMethod = .post
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = false
    
    var httpBody: RegisterRequestBody?
    
    init(
        httpBody: RegisterRequestBody
    ) {
        self.httpBody = httpBody
    }
}

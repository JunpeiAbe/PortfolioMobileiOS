import Foundation

struct AppInformationRequest: APIRequest {
    typealias Response = AppInformationResponse
    
    typealias HttpBody = EmptyBody
    
    var path: String = "app/information"
    
    var httpMethod: HttpMethod = .get
    
    var httpBody: EmptyBody?
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = false
}

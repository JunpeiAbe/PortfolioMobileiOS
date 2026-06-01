import Foundation

struct AppInformationRequest: @MainActor APIRequest {
    typealias Response = AppInformationResponse
    
    typealias HttpBody = EmptyBody
    
    var path: String = "/infomation"
    
    var httpMethod: HttpMethod = .get
    
    var httpBody: EmptyBody?
    
    var httpHeaderFields: [String : String] = [:]
    
    var requiresAuthorization: Bool = false
}

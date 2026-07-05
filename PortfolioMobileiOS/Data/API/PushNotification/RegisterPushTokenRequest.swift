import Foundation

struct RegisterPushTokenRequest: APIRequest {
    typealias Response = RegisterPushTokenResponse
    typealias Body = RegisterPushTokenRequestBody

    var path: String = "devices/push-token"
    var httpMethod: HttpMethod = .put
    var httpHeaderFields: [String: String] = [:]
    var requiresAuthorization: Bool = true
    var httpBody: RegisterPushTokenRequestBody?

    init(httpBody: RegisterPushTokenRequestBody) {
        self.httpBody = httpBody
    }
}

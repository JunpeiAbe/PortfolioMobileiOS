import Foundation

struct APIConfiguration {
    let baseURL: URL
    let defaultHeaders: [String : String]
    
    init(
        baseURL: URL,
        defaultHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
    }
}

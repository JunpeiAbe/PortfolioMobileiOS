import Foundation

struct AppInformationResponse: @MainActor APIResponse {
    let isMaintenance: Bool?
    let androidMinAppVersion: String?
    let iOSMinAppVersion: String?
    let appTermURL: String?
    let appTermVersion: String?
    let qaURL: String?
    let error: CommonResponseError?
    
    enum CodingKeys: String, CodingKey {
        case isMaintenance = "maintenance_flag"
        case androidMinAppVersion = "android_min_app_version"
        case iOSMinAppVersion = "ios_min_app_version"
        case appTermURL = "app_term_url"
        case appTermVersion = "app_term_version"
        case qaURL = "qa_url"
        case error
    }
}

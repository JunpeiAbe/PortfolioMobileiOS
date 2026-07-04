import Foundation

extension Bundle {
    var apiBaseURL: URL {
        guard
            let string = object(
                forInfoDictionaryKey: "API_BASE_URL"
            ) as? String,
            let url = URL(string: string)
        else {
            fatalError("API_BASE_URL is invalid")
        }
        return url
    }
}

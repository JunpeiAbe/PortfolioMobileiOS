import Foundation

extension URLSession {
    static var stub: URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [
            MockURLProtcol.self
        ]
        return URLSession(configuration: configuration)
    }
}

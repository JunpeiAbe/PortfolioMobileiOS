import Foundation

extension URLSession {
    static var stub: URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [
            MockURLProtocol.self
        ]
        return URLSession(configuration: configuration)
    }
}

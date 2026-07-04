import Foundation

enum StubResponseConfigurator {
    static func configure() {
        MockURLProtocol.requestHandler = { request in
            let fileName: String = try Self.fileName(for: request)
            let data: Data = try Self.loadJSON(fileName: fileName)
            guard let url = request.url else {
                throw APIClientError.requestBuildFailed
            }
            let response: HTTPURLResponse = .init(
                url: url,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: [
                    "Content-Type": "application/json"
                ]
            )!
            return (response, data)
        }
    }
    
    static func fileName(for request: URLRequest) throws -> String {
        guard let path = request.url?.path else {
            throw APIClientError.requestBuildFailed
        }
        switch path {
        case "/app/information":
            return "app_information_success"
        case "/auth/login":
            return "login_success"
        case "/auth/register":
            return "register_success"
        case "/auth/refresh":
            return "refresh_success"
        case "/terms/agree":
            return "agree_term_success"
        case "/notices":
            return "notices_success"
        case "/features":
            return "features_success"
        default:
            throw APIClientError.requestBuildFailed
        }
    }
    
    static func loadJSON(fileName: String) throws -> Data {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw APIClientError.requestBuildFailed
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw APIClientError.unknown
        }
    }
}

import Foundation
import Testing
@testable import PortfolioMobileiOS

@Suite("URLSessionAPIClient", .serialized)
struct URLSessionAPIClientTests {
    struct TokenProvider: AccessTokenProviding {
        let token: String?
        let error: (any Error)?
        func getAccessToken() async throws -> String? {
            if let error { throw error }
            return token
        }
    }

    // URL、method、JSON Body、既定Headerが正しく組み立てられることを検証する。
    @Test func makeURLRequest() async throws {
        let client = URLSessionAPIClient(
            configuration: .init(baseURL: URL(string: "https://example.com/api")!)
        )
        let request = LoginRequest(httpBody: .init(mailAddress: "user@example.com", password: "Abcdef1!"))
        let urlRequest = try await client.makeURLRequest(request)
        #expect(urlRequest.url?.absoluteString == "https://example.com/api/auth/login")
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let body = try #require(urlRequest.httpBody)
        let json = try #require(JSONSerialization.jsonObject(with: body) as? [String: String])
        #expect(json["mail_address"] == "user@example.com")
        #expect(json["password"] == "Abcdef1!")
    }

    // 認証必須RequestへBearer Tokenを設定することを検証する。
    @Test func authorizationHeader() async throws {
        let client = URLSessionAPIClient(
            configuration: .init(baseURL: URL(string: "https://example.com")!),
            accessTokenProvider: TokenProvider(token: "access-token", error: nil)
        )
        let result = try await client.makeURLRequest(FeaturesRequest(limit: 20, cursor: "next"))
        #expect(result.value(forHTTPHeaderField: "Authorization") == "Bearer access-token")
        #expect(result.url?.query?.contains("cursor=next") == true)
    }

    // Tokenがnilまたは空文字の場合に認証エラーとする境界をまとめて検証する。
    @Test(arguments: [nil, ""] as [String?])
    func missingAuthorizationToken(token: String?) async {
        let client = URLSessionAPIClient(
            configuration: .init(baseURL: URL(string: "https://example.com")!),
            accessTokenProvider: TokenProvider(token: token, error: nil)
        )
        await #expect(throws: APIClientError.getAccessTokenFailed) {
            _ = try await client.makeURLRequest(FeaturesRequest(limit: 20, cursor: nil))
        }
    }

    // 200番台レスポンスを期待するResponse型へデコードすることを検証する。
    @Test func successfulResponse() async throws {
        let client = makeMockClient(statusCode: 200, data: Data("{\"access_token\":\"a\",\"refresh_token\":\"r\",\"app_terms_agreed\":true,\"error\":null}".utf8))
        let response = try await client.send(LoginRequest(httpBody: .init(mailAddress: "a@b.co", password: "Abcdef1!")))
        #expect(response.accessToken == "a")
        #expect(response.appTermsAgreed == true)
    }

    // 200番台以外のHTTP statusをinvalidResponseへ変換することを検証する。
    @Test(arguments: [400, 401, 404, 500, 503])
    func invalidHTTPStatus(statusCode: Int) async {
        let client = makeMockClient(statusCode: statusCode, data: Data())
        await #expect(throws: APIClientError.invalidResponse(statusCode)) {
            _ = try await client.send(AppInformationRequest())
        }
    }

    // 不正JSONをdecodingFailedへ変換することを検証する。
    @Test func decodingFailure() async {
        let client = makeMockClient(statusCode: 200, data: Data("invalid".utf8))
        await #expect(throws: APIClientError.decodingFailed) {
            _ = try await client.send(AppInformationRequest())
        }
    }

    private func makeMockClient(statusCode: Int, data: Data) -> URLSessionAPIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.requestHandler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!, data)
        }
        return URLSessionAPIClient(
            session: URLSession(configuration: configuration),
            configuration: .init(baseURL: URL(string: "https://example.com")!)
        )
    }
}

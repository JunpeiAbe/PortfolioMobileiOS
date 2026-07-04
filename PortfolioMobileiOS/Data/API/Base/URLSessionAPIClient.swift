import Foundation

struct URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let accessTokenProvider: AccessTokenProviding?
    init(
        session: URLSession = .init(configuration: .default),
        configuration: APIConfiguration,
        accessTokenProvider: AccessTokenProviding? = nil
    ) {
        self.session = session
        self.configuration = configuration
        self.accessTokenProvider = accessTokenProvider
    }
    
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, response): (Data, URLResponse)
        do {
            let urlRequest = try await makeURLRequest(request)
            print("session start:",urlRequest)
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as APIClientError {
            print("APIClientError:",error)
            throw error
        } catch let error as URLError {
            print("URLError:",error)
            if (error.errorCode == NSURLErrorNotConnectedToInternet || error.errorCode == NSURLErrorTimedOut) {
                throw APIClientError.notConnectedToInternet
            } else {
                throw APIClientError.unknown
            }
        } catch {
            print("Unknown Error:",error)
            throw APIClientError.unknown
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw APIClientError.invalidResponse(httpResponse.statusCode)
        }
        do {
            let response = try JSONDecoder().decode(Request.Response.self, from: data)
            return response
        } catch {
            print("error:\(error)")
            throw APIClientError.decodingFailed
        }
    }
    
    /// URLリクエスト生成
    func makeURLRequest<Request: APIRequest>(_ request: Request) async throws -> URLRequest {
        print("makeURLRequest")
        let url = configuration.baseURL.appendingPathComponent(request.path)
        guard var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) else {
            throw APIClientError.requestBuildFailed
        }
        components.queryItems = request.queryItems.isEmpty ? nil : request.queryItems
        guard let url = components.url else { throw APIClientError.requestBuildFailed }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        let headers = try await makeHeaders(for: request)
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        if let httpBody = request.httpBody {
            do {
                let data = try JSONEncoder().encode(httpBody)
                urlRequest.httpBody = data
            } catch {
                throw APIClientError.encodingFailed
            }
        }
        return urlRequest
    }
    /// HTTPヘッダー生成
    private func makeHeaders<Request: APIRequest>(
        for request: Request
    ) async throws -> [String: String] {
        print("makeHeaders")
        var headers = configuration.defaultHeaders
        request.httpHeaderFields.forEach { key, value in
            headers[key] = value
        }
        if request.requiresAuthorization {
            guard let token = try await accessTokenProvider?.getAccessToken(),
                  !token.isEmpty else {
                throw APIClientError.getAccessTokenFailed
            }
            headers["Authorization"] = "Bearer \(token)"
            print("token:\(token)")
        }
        return headers
    }
}


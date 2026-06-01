import Foundation

struct URLsessionAPIClient: APIClient {
    var session: URLSession
    
    init(
        session: URLSession = .init(
            configuration: .default
        )
    ) {
        self.session = session
    }
    
    func send<Request>(_ request: Request) async throws -> Request.Response where Request : APIRequestable {
        let (data, response): (Data, URLResponse)
        do {
            let urlRequest = try await request.makeURLRequest()
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as APIClientError {
            throw error
        } catch let error as URLError {
            if (error.errorCode == NSURLErrorNotConnectedToInternet || error.errorCode == NSURLErrorTimedOut) {
                throw APIClientError.notConnectedToInternet
            } else {
                throw APIClientError.unknown
            }
        } catch {
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
            throw APIClientError.decodingFailed
        }
    }
}


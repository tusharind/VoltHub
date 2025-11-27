import Foundation

final class DefaultAPIService: APIService {

    private let baseURL: URL
    private let urlSession: URLSession

    init(
        baseURL: URL,
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request: URLRequest
        do {
            request = try endpoint.makeRequest(baseURL: baseURL)
        } catch {
            throw APIError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            if (error as NSError).code == NSURLErrorTimedOut {
                throw APIError.timeout
            } else {
                throw APIError.network(error)
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.custom("Invalid Response")
        }

        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 500..<600:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.httpStatus(httpResponse.statusCode, data)
        }

        guard !data.isEmpty else {
            throw APIError.noData
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}

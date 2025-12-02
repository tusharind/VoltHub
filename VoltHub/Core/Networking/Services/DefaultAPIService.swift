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
            throw APIError.message("Invalid Response")
        }

        let status = httpResponse.statusCode
        guard (200..<300).contains(status) else {
            throw APIError.message(
                extractErrorMessage(from: data) ?? "Request failed",
                code: status
            )
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

    private func extractErrorMessage(from data: Data) -> String? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data)
                as? [String: Any]
        else {
            return nil
        }

        if let message = json["message"] as? String {
            return message
        }
        if let error = json["error"] as? String {
            return error
        }
        if let errorMessage = json["errorMessage"] as? String {
            return errorMessage
        }
        if let detail = json["detail"] as? String {
            return detail
        }

        return nil
    }

}

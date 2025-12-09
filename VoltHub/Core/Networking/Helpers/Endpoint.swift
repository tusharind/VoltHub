import SwiftUI

struct Endpoint {
    let path: String
    var method: HTTPMethod = .get
    var query: [String: String] = [:]
    var headers: [String: String] = [:]
    var body: Encodable? = nil
    var requiresAuth: Bool = true

    func makeRequest(baseURL: URL) throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)

        if !query.isEmpty {
            url = url.appending(queryItems: query.map { URLQueryItem(name: $0, value: $1) })
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}



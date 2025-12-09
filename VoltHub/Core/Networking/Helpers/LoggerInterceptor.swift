import Foundation

struct LoggerInterceptor: RequestInterceptor {
    func prepare(_ request: URLRequest, endpoint: Endpoint) -> URLRequest {
        #if DEBUG
            let method = request.httpMethod ?? "GET"
            let urlString = request.url?.absoluteString ?? "<nil URL>"
            print("[Request] \(method) \(urlString)")
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                print("   Headers: \(headers)")
            }
            if let body = request.httpBody, !body.isEmpty {
                let sizeKB = Double(body.count) / 1024.0
                print(String(format: "   Body: %.2f KB", sizeKB))
            }
        #endif
        return request
    }

    func didReceive(
        _ response: URLResponse?,
        data: Data?,
        for request: URLRequest,
        endpoint: Endpoint
    ) {
        #if DEBUG
            let urlString = request.url?.absoluteString ?? "<nil URL>"
            if let http = response as? HTTPURLResponse {
                print("[Response] \(http.statusCode) \(urlString)")
                if let data = data, !data.isEmpty {
                    let sizeKB = Double(data.count) / 1024.0
                    print(String(format: "   Data: %.2f KB", sizeKB))
                }
            } else {
                print("[Response] <non-HTTP> \(urlString)")
            }
        #endif
    }
}

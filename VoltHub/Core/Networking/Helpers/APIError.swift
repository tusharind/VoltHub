import Foundation

enum APIError: Error, LocalizedError {

    case invalidURL
    case network(Error)
    case timeout
    case noData
    case decoding(Error)

    case message(String, code: Int? = nil)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .network:
            return "Network error"
        case .timeout:
            return "Timeout"
        case .noData:
            return "No data"
        case .decoding:
            return "Invalid data"
        case .message(let msg, _):
            return msg
        }
    }
}


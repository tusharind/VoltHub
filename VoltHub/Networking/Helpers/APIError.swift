import Foundation

enum APIError: Error, LocalizedError {

    case invalidURL
    case network(Error)
    case noData
    case timeout
    
    case httpStatus(Int, Data?)
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    
    case decoding(Error)
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .network(let err):
            return "Network error: \(err.localizedDescription)"
        case .noData:
            return "No data received from the server."
        case .timeout:
            return "The request timed out."
        case .httpStatus(let code, _):
            return "HTTP Error: \(code)"
        case .unauthorized:
            return "Unauthorized access."
        case .forbidden:
            return "Access forbidden."
        case .notFound:
            return "Resource not found."
        case .serverError(let code):
            return "Server error (\(code))."
        case .decoding(let err):
            return "Decoding error: \(err.localizedDescription)"
        case .custom(let message):
            return message
        }
    }
}


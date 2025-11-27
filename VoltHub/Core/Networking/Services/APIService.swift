import Foundation

protocol APIService {
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T
}

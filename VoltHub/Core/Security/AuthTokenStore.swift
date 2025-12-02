import Foundation

protocol AuthTokenStore {
    func save(token: String) throws
    func getToken() throws -> String?
    func clear() throws
}

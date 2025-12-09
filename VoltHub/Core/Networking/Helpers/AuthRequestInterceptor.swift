import Foundation

struct AuthRequestInterceptor: RequestInterceptor {
    let tokenStore: AuthTokenStore

    func prepare(_ request: URLRequest, endpoint: Endpoint) -> URLRequest {
        guard endpoint.requiresAuth else { return request }
        var req = request
        do {
            if let token = try tokenStore.getToken(), !token.isEmpty {
                req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        } catch {
            
        }
        return req
    }
}

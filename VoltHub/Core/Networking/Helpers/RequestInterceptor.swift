import Foundation

protocol RequestInterceptor {

    func prepare(_ request: URLRequest, endpoint: Endpoint) -> URLRequest

    func didReceive(
        _ response: URLResponse?,
        data: Data?,
        for request: URLRequest,
        endpoint: Endpoint
    )
}

extension RequestInterceptor {
    func didReceive(
        _ response: URLResponse?,
        data: Data?,
        for request: URLRequest,
        endpoint: Endpoint
    ) {

    }
}

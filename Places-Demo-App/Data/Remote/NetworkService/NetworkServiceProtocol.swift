import Foundation

/// HTTP methods supported by the network service.
enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Protocol defining an API endpoint that can build a `URLRequest`.
protocol EndpointProtocol: Sendable {

    /// Path segment appended to the configuration base URL.
    var path: String { get }

    /// HTTP method for the request.
    var method: HTTPMethod { get }

    /// Builds a URLRequest using the given configuration.
    /// - Parameter configuration: Base URL, headers, and timeout.
    /// - Returns: Configured URLRequest.
    func urlRequest(with configuration: NetworkConfiguration) throws -> URLRequest
}

/// Protocol for network service operations. Implementations perform HTTP requests and decode responses.
protocol NetworkServiceProtocol: Sendable {

    /// Performs a network request and decodes the response to the given type.
    /// - Parameter endpoint: Endpoint conforming to `EndpointProtocol`.
    /// - Returns: Decoded value of type `T`.
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T
}

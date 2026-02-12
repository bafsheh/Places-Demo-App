//
//  NetworkServiceProtocol.swift
//  Places-Demo-App
//
//  Purpose: Defines HTTP methods, endpoint contract, and network service contract.
//  Dependencies: NetworkConfiguration.
//  Usage: EndpointProtocol/NetworkServiceProtocol implemented by LocationsEndpoint and NetworkService.
//

import Foundation

/// HTTP methods supported by the network service.
///
/// - SeeAlso: `EndpointProtocol`, `NetworkService`
enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Contract for an API endpoint that can build a `URLRequest` from a network configuration.
///
/// Conform to this protocol to add new API endpoints (e.g. locations, favorites) without changing the network service.
///
/// - SeeAlso: `LocationsEndpoint`, `NetworkConfiguration`, `NetworkServiceProtocol`
protocol EndpointProtocol: Sendable {

    /// Path segment appended to the configuration base URL (e.g. `"/path/to/resource"`).
    var path: String { get }

    /// HTTP method for the request.
    var method: HTTPMethod { get }

    /// Builds a URLRequest using the given configuration.
    ///
    /// - Parameter configuration: Base URL, headers, and timeout.
    /// - Returns: Configured URLRequest ready for the network layer.
    /// - Throws: `NetworkError.invalidURL` if the composed URL is invalid.
    func urlRequest(with configuration: NetworkConfiguration) throws -> URLRequest
}

/// Contract for performing HTTP requests and decoding JSON responses.
///
/// Implementations (e.g. `NetworkService` actor) isolate I/O and are safe to use from concurrent contexts.
///
/// - SeeAlso: `NetworkService`, `EndpointProtocol`, `NetworkError`
protocol NetworkServiceProtocol: Sendable {

    /// Performs a network request for the given endpoint and decodes the response to type `T`.
    ///
    /// - Parameter endpoint: Endpoint conforming to `EndpointProtocol` (path, method, URLRequest builder).
    /// - Returns: Decoded value of type `T` (e.g. `LocationsResponse`).
    /// - Throws: `NetworkError` for invalid URL, non-2xx status, or decoding failure.
    func request<T: Decodable & Sendable>(_ endpoint: EndpointProtocol) async throws -> T
}

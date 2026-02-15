//
//  NetworkService.swift
//  Places-Demo-App
//
//  Purpose: Performs HTTP requests and decodes JSON; actor for concurrency safety.
//  Dependencies: URLSession, NetworkConfiguration, EndpointProtocol, NetworkError.
//  Usage: Injected into RemoteDataSource; used only in DependencyContainer.
//

import Foundation

/// Actor that performs HTTP requests and decodes JSON responses.
///
/// Isolates network I/O so it is safe to use from concurrent contexts. Validates HTTP status (2xx) and maps failures to `NetworkError`.
///
actor NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    private let configuration: NetworkConfiguration
    private let decoder: JSONDecoder

    /// Creates a network service with optional custom session and decoder.
    ///
    /// - Parameters:
    ///   - session: URLSession for performing requests; defaults to `.shared`.
    ///   - configuration: Base URL, headers, and timeout used when building requests.
    ///   - decoder: JSON decoder for response bodies; defaults to `JSONDecoder()`.
    init(
        session: URLSession = .shared,
        configuration: NetworkConfiguration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }

    /// Performs a network request for the given endpoint and decodes the response to type `T`.
    ///
    /// - Parameter endpoint: Endpoint that provides path, method, and URLRequest.
    /// - Returns: Decoded value of type `T`.
    /// - Throws: `NetworkError` for non-HTTP response, non-2xx status, or decoding failure.
    func request<T: Decodable & Sendable>(_ endpoint: EndpointProtocol) async throws -> T {
        let request = try await endpoint.urlRequest(with: configuration)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.networkFailure(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}

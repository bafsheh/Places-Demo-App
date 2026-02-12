//
//  LocationsEndpoint.swift
//  Places-Demo-App
//
//  Purpose: Defines the locations API endpoint (path, method, URLRequest builder).
//  Dependencies: EndpointProtocol, NetworkConfiguration, NetworkError.
//  Usage: Used by RemoteDataSource when calling NetworkService.request.
//

import Foundation

/// Endpoint for the locations API.
///
/// Defines path, method, and URLRequest builder for the single locations resource. To add more remote entities, introduce a new DTO, response type, and endpoint (e.g. FavoritesEndpoint).
///
enum LocationsEndpoint: EndpointProtocol, Sendable {

    /// The locations list endpoint (e.g. JSON list of places).
    case locations

    /// Path segment appended to the configuration base URL.
    var path: String {
        switch self {
        case .locations:
            return "/abnamrocoesd/assignment-ios/main/locations.json"
        }
    }

    /// HTTP method for this endpoint (GET).
    var method: HTTPMethod {
        .get
    }

    /// Builds a URLRequest for this endpoint using the given configuration.
    ///
    /// - Parameter configuration: Base URL, headers, and timeout.
    /// - Returns: Configured URLRequest.
    /// - Throws: `NetworkError.invalidURL` if base URL + path is invalid.
    func urlRequest(with configuration: NetworkConfiguration) throws -> URLRequest {
        guard let url = URL(string: configuration.baseURL + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = configuration.timeout

        configuration.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

//
//  RemoteDataSource.swift
//  Places-Demo-App
//

import Foundation

/// Remote data source that fetches locations via the network service and returns DTOs.
final class RemoteDataSource: RemoteDataSourceProtocol {

    private let networkService: NetworkServiceProtocol
    private let configuration: NetworkConfiguration

    /// Creates a remote data source with the given network service and configuration.
    /// - Parameters:
    ///   - networkService: Service used to perform the HTTP request.
    ///   - configuration: Used when building the endpoint URLRequest.
    init(
        networkService: NetworkServiceProtocol,
        configuration: NetworkConfiguration
    ) {
        self.networkService = networkService
        self.configuration = configuration
    }

    /// Fetches locations from the remote API and returns the raw DTO array.
    func fetchLocations() async throws -> [LocationDTO] {
        let endpoint = Endpoint.locations
        let response: LocationsResponse = try await networkService.request(endpoint)
        return response.locations
    }
}

// MARK: - Endpoint

private extension RemoteDataSource {
    enum Endpoint {
        case locations

        var path: String {
            switch self {
            case .locations:
                return "/abnamrocoesd/assignmentios/main/locations.json"
            }
        }

        var method: HTTPMethod {
            .get
        }
    }
}

extension RemoteDataSource.Endpoint: EndpointProtocol {
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

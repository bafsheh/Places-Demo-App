//
//  RemoteDataSource.swift
//  Places-Demo-App
//
//  Purpose: Fetches locations from the remote API via NetworkService; returns DTOs.
//  Dependencies: NetworkServiceProtocol, NetworkConfiguration, LocationsEndpoint, LocationDTO.
//  Usage: Injected into LocationRepository; used only in DependencyContainer.
//

import Foundation

/// Fetches locations from the remote API via the network service and returns DTOs.
///
/// Uses `LocationsEndpoint.locations` and decodes `LocationsResponse`; does not map to domain entities (repository does that).
///
/// - SeeAlso: `RemoteDataSourceProtocol`, `NetworkService`, `LocationRepository`, `LocationDTO`
final class RemoteDataSource: RemoteDataSourceProtocol {

    private let networkService: NetworkServiceProtocol
    private let configuration: NetworkConfiguration

    /// Creates a remote data source with the given network service and configuration.
    ///
    /// - Parameters:
    ///   - networkService: Service used to perform the HTTP request and decode JSON.
    ///   - configuration: Used by the endpoint to build the URLRequest (base URL, headers, timeout).
    init(
        networkService: NetworkServiceProtocol,
        configuration: NetworkConfiguration
    ) {
        self.networkService = networkService
        self.configuration = configuration
    }

    /// Fetches locations from the remote API.
    ///
    /// - Returns: Array of location DTOs from the decoded response.
    /// - Throws: Errors from the network service (e.g. `NetworkError`).
    func fetchLocations() async throws -> [LocationDTO] {
        let endpoint = LocationsEndpoint.locations
        let response: LocationsResponse = try await networkService.request(endpoint)
        return response.locations
    }
}

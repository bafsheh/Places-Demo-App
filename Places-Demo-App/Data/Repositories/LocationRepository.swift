//
//  LocationRepository.swift
//  Places-Demo-App
//
//  Purpose: Fetches locations from RemoteDataSource and maps DTOs to domain Location.
//  Dependencies: RemoteDataSourceProtocol, LocationDTO, Location.
//  Usage: Injected into FetchLocationsUseCase; created in DependencyContainer.
//

import Foundation

/// Fetches locations from the remote data source and maps DTOs to domain `Location` entities.
///
/// Implements `LocationRepositoryProtocol`; used by `FetchLocationsUseCase`. Each DTO is mapped via `toDomain()` (new UUID per location).
///
final class LocationRepository: LocationRepositoryProtocol {

    private let remoteDataSource: RemoteDataSourceProtocol

    /// Creates the repository with the given remote data source.
    ///
    /// - Parameter remoteDataSource: Source of location DTOs (e.g. `RemoteDataSource` or a test mock).
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    /// Fetches locations from the remote source and maps them to domain entities.
    ///
    /// - Returns: Array of domain `Location` entities.
    /// - Throws: Errors from the data source (e.g. network or decoding failures).
    func fetchLocations() async throws -> [Location] {
        let dtos = try await remoteDataSource.fetchLocations()
        return dtos.map { $0.toDomain() }
    }
}

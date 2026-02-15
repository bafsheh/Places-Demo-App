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
    /// - Throws: Domain `LocationFetchError` so callers (e.g. use case, ViewModel) do not depend on Data-layer errors.
    func fetchLocations() async throws -> [Location] {
        do {
            let dtos = try await remoteDataSource.fetchLocations()
            return dtos.map { $0.toDomain() }
        } catch let error as NetworkError {
            throw Self.mapToLocationFetchError(error)
        } catch {
            throw LocationFetchError.unknown
        }
    }

    /// Maps Data-layer `NetworkError` to Domain `LocationFetchError` so the repository's public API is domain-only.
    private static func mapToLocationFetchError(_ error: NetworkError) -> LocationFetchError {
        switch error {
        case .noData, .networkFailure, .httpError:
            return .networkUnavailable
        case .invalidURL, .decodingError:
            return .invalidData
        case .unknown:
            return .unknown
        }
    }
}

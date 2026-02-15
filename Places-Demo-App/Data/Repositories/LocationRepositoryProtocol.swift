//
//  LocationRepositoryProtocol.swift
//  Places-Demo-App
//
//  Purpose: Contract for fetching locations from a data source (remote or test double).
//  Dependencies: None.
//  Usage: Injected into FetchLocationsUseCase; implemented by LocationRepository.
//

import Foundation

/// Contract for fetching locations from a data source (remote API or test double).
///
/// Implementations are responsible for loading location data and mapping to domain `Location` entities.
/// Injected into `FetchLocationsUseCase` so tests can use a mock repository.
///
protocol LocationRepositoryProtocol: Sendable {

    /// Fetches all locations from the underlying source.
    ///
    /// - Returns: Array of domain `Location` entities.
    /// - Throws: Domain errors (e.g. `LocationFetchError`) when the fetch fails.
    func fetchLocations() async throws -> [Location]
}

//
//  FetchLocationsUseCase.swift
//  Places-Demo-App
//
//  Purpose: Use case to fetch locations from the repository; protocol allows test doubles.
//  Dependencies: LocationRepositoryProtocol, Location.
//  Usage: Injected into LocationListViewModel via Dependencies.
//

import Foundation

/// Contract for the fetch-locations use case; allows injection of mocks in tests.
///
/// - SeeAlso: `FetchLocationsUseCase`, `LocationRepositoryProtocol`, `Location`
protocol FetchLocationsUseCaseProtocol: Sendable {

    /// Fetches the current list of locations from the repository.
    ///
    /// - Returns: Array of domain `Location` entities.
    /// - Throws: Errors from the repository (e.g. network or decoding failures).
    func execute() async throws -> [Location]
}

/// Use case that fetches locations from the repository for display in the list.
///
/// Delegates to `LocationRepositoryProtocol`; used by `LocationListViewModel` to load data on appear and retry.
///
/// - SeeAlso: `LocationRepositoryProtocol`, `LocationListViewModel`, `Location`
final class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {

    private let repository: LocationRepositoryProtocol

    /// Creates the use case with the given repository.
    ///
    /// - Parameter repository: Data source for locations (e.g. `LocationRepository` or a test mock).
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }

    /// Fetches locations from the repository.
    ///
    /// - Returns: Array of domain `Location` entities.
    /// - Throws: Errors propagated from the repository (e.g. `NetworkError`).
    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}

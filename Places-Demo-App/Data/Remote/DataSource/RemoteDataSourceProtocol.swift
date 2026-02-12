//
//  RemoteDataSourceProtocol.swift
//  Places-Demo-App
//
//  Purpose: Contract for fetching location data from a remote source (API or mock).
//  Dependencies: LocationDTO.
//  Usage: Implemented by RemoteDataSource; injected into LocationRepository.
//

import Foundation

/// Contract for fetching location data from a remote source (API or test double).
///
/// Implementations typically call a network service and return raw DTOs; the repository maps them to domain entities.
///
/// - SeeAlso: `RemoteDataSource`, `LocationRepository`, `LocationDTO`
protocol RemoteDataSourceProtocol: Sendable {

    /// Fetches locations from the remote source.
    ///
    /// - Returns: Array of location DTOs (e.g. from the locations JSON API).
    /// - Throws: Network or decoding errors when the request fails.
    func fetchLocations() async throws -> [LocationDTO]
}

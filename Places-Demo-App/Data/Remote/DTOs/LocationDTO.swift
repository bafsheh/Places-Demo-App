//
//  LocationDTO.swift
//  Places-Demo-App
//
//  Purpose: API response shapes for locations; maps to domain Location.
//  Dependencies: None.
//  Usage: Used by RemoteDataSource and LocationsEndpoint response decoding.
//

import Foundation

/// Data transfer object for a single location as returned by the locations API.
///
/// Property names match the API (e.g. `lat`/`long`); use `toDomain()` to obtain a domain `Location` with a new UUID.
/// Safe to use across isolation boundaries: value type, `Sendable`, immutable (`let` only). Decoded inside
/// `NetworkService` (actor) and passed to nonisolated callers and then to `@MainActor` view model without data races.
struct LocationDTO: Codable, Sendable {

    /// Optional display name from the API.
    let name: String?

    /// Latitude in degrees.
    let lat: Double

    /// Longitude in degrees.
    let long: Double

    /// Maps this DTO to a domain `Location` (generates a new `id`).
    ///
    /// Creates a `Location` with a domain `Coordinate` from `lat`/`long`; no CoreLocation types in Domain.
    /// - Returns: A `Location` with the same name and coordinates.
    func toDomain() -> Location {
        Location(
            name: name,
            latitude: lat,
            longitude: long
        )
    }
}

/// Top-level response shape for the locations API; contains an array of location DTOs.
/// Value type, `Sendable`, immutable—safe to pass from `NetworkService` (actor) to callers on any isolation.
struct LocationsResponse: Codable, Sendable {

    /// Array of location DTOs from the API.
    let locations: [LocationDTO]
}

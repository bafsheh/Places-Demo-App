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
/// Explicit `nonisolated` Codable is required because the project uses `default-isolation=MainActor`,
/// which makes compiler-synthesized conformances main-actor-isolated and incompatible with the
/// `Sendable` constraint on `NetworkServiceProtocol.request`.
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

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        lat = try container.decode(Double.self, forKey: .lat)
        long = try container.decode(Double.self, forKey: .long)
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(lat, forKey: .lat)
        try container.encode(long, forKey: .long)
    }

    private enum CodingKeys: String, CodingKey {
        case name, lat, long
    }
}

/// Top-level response shape for the locations API; contains an array of location DTOs.
///
/// Explicit `nonisolated` Codable required due to project-wide `default-isolation=MainActor`.
struct LocationsResponse: Codable, Sendable {

    /// Array of location DTOs from the API.
    let locations: [LocationDTO]

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        locations = try container.decode([LocationDTO].self, forKey: .locations)
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(locations, forKey: .locations)
    }

    private enum CodingKeys: String, CodingKey {
        case locations
    }
}

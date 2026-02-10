import Foundation

/// Data Transfer Object for Location from API
struct LocationDTO: Codable, Sendable {
    let name: String?
    let lat: Double
    let long: Double

    /// Maps DTO to Domain Entity
    func toDomain() -> Location {
        Location(
            name: name,
            latitude: lat,
            longitude: long
        )
    }
}

/// Response wrapper for locations API
struct LocationsResponse: Codable, Sendable {
    let locations: [LocationDTO]
}

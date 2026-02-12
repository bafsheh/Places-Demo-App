//
//  Coordinate.swift
//  Places-Demo-App
//
//  Purpose: Domain model for geographic coordinates. Pure value type with no framework dependencies.
//  Dependencies: Foundation only.
//  Usage: Use in all domain entities (e.g. Location) instead of CLLocationCoordinate2D; map to/from CLLocationCoordinate2D in the Data layer when needed.
//

import Foundation

/// Domain model for geographic coordinates
///
/// Pure value type with no framework dependencies.
/// Use this in all domain entities instead of CLLocationCoordinate2D.
struct Coordinate: Equatable, Sendable {

    /// Latitude in degrees (-90 to 90)
    let latitude: Double

    /// Longitude in degrees (-180 to 180)
    let longitude: Double

    /// Initialize coordinate with validation
    ///
    /// - Parameters:
    ///   - latitude: Latitude in degrees
    ///   - longitude: Longitude in degrees
    /// - Note: Values outside valid ranges will be clamped
    init(latitude: Double, longitude: Double) {
        self.latitude = max(-90, min(90, latitude))
        self.longitude = max(-180, min(180, longitude))
    }
}

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

    /// Valid latitude range in degrees.
    static let latitudeRange = -90.0...90.0

    /// Valid longitude range in degrees.
    static let longitudeRange = -180.0...180.0

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
        self.latitude = min(max(Self.latitudeRange.lowerBound, latitude), Self.latitudeRange.upperBound)
        self.longitude = min(max(Self.longitudeRange.lowerBound, longitude), Self.longitudeRange.upperBound)
    }
}

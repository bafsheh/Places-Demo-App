//
//  Location.swift
//  Places-Demo-App
//
//  Purpose: Domain model for a geographic place (coordinates and optional name).
//  Dependencies: Foundation only.
//  Usage: Used by use cases, views, and DTO mapping.
//

import Foundation

/// Represents a geographic location with coordinates and optional name.
///
/// Used across the app for list display, add-location form, and deep linking to Wikipedia.
/// Conforms to `Identifiable` (by `id`), `Equatable` (by `id`), and `Sendable` for safe use from async contexts.
///
struct Location: Identifiable, Equatable, Hashable, Sendable {

    /// Unique identifier for the location; defaults to a new UUID when created from user input.
    let id: UUID

    /// Optional display name (e.g. from API or user-entered).
    let name: String?

    /// Latitude and longitude; used for display and deep link query parameters.
    let coordinate: Coordinate

    /// Creates a location with the given coordinates and optional name.
    ///
    /// - Parameters:
    ///   - id: Unique identifier; defaults to a new UUID.
    ///   - name: Optional display name.
    ///   - latitude: Latitude in degrees (-90...90).
    ///   - longitude: Longitude in degrees (-180...180).
    init(
        id: UUID = UUID(),
        name: String? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.name = name
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
    }

    /// Display name for UI; falls back to `"Unknown"` when `name` is nil.
    var displayName: String {
        name ?? LocalizationHelper.Location.unnamedLocation
    }

    /// Coordinates formatted as `"lat, long"` with four decimal places.
    var formattedCoordinates: String {
        String(
            format: "%.4f, %.4f",
            coordinate.latitude,
            coordinate.longitude
        )
    }

    /// Equality is identity-based (by UUID).
    ///
    /// Two locations with the same ID but different coordinates/names are considered equal.
    /// This supports SwiftUI list identity semantics - when a location's data changes,
    /// SwiftUI uses the ID to track it, but changes to name/coordinates won't trigger
    /// Equatable-based updates. For value-based comparison, compare properties directly.
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

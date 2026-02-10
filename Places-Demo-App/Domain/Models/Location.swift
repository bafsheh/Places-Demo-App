import Foundation
import CoreLocation

/// Represents a geographic location with coordinates
struct Location: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String?
    let coordinate: CLLocationCoordinate2D

    init(
        id: UUID = UUID(),
        name: String? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.name = name
        self.coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }

    /// Formatted display name
    var displayName: String {
        name ?? "Unknown"
    }

    /// Formatted coordinates
    var formattedCoordinates: String {
        String(
            format: "%.4f, %.4f",
            coordinate.latitude,
            coordinate.longitude
        )
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - CLLocationCoordinate2D Extension

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

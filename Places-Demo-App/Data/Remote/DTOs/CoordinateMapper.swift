//
//  CoordinateMapper.swift
//  Places-Demo-App
//
//  Purpose: Maps between Domain Coordinate and CoreLocation CLLocationCoordinate2D.
//  Dependencies: CoreLocation, Foundation.
//  Usage: Use in the Data layer when interfacing with MapKit, CoreLocation, or any APIs requiring CLLocationCoordinate2D.
//

import CoreLocation
import Foundation

/// Maps between Domain Coordinate and CoreLocation CLLocationCoordinate2D
///
/// Use this in the Data layer when interfacing with MapKit, CoreLocation,
/// or any APIs requiring CLLocationCoordinate2D.
enum CoordinateMapper {

    /// Convert domain Coordinate to CLLocationCoordinate2D
    static func toCoreLocation(_ coordinate: Coordinate) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }

    /// Convert CLLocationCoordinate2D to domain Coordinate
    static func toDomain(_ coordinate: CLLocationCoordinate2D) -> Coordinate {
        Coordinate(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
}

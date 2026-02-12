//
//  SampleData.swift
//  Places-Demo-AppTests
//
//  Purpose: Centralized sample data for tests (nonisolated for use as default values).
//  Dependencies: @testable Places_Demo_App, Location.
//  Usage: SampleData.locations, SampleData.sampleLocation.
//

import Foundation
@testable import Places_Demo_App

/// Sample data for tests.
@MainActor
enum SampleData {
    /// Sample locations for testing
    static let locations: [Location] = [
        Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041),
        Location(name: "Rotterdam", latitude: 51.9225, longitude: 4.4792),
        Location(name: "Utrecht", latitude: 52.0907, longitude: 5.1214)
    ]

    /// Single sample location
    static let sampleLocation = locations[0]
}

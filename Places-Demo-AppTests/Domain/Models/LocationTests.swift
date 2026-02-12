//
//  LocationTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@MainActor
@Suite("Location init, displayName, formattedCoordinates and Equatable")
struct LocationTests {

    @Test("init with name sets name and coordinate")
    func init_withName() {
        let loc = Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89)
        #expect(loc.name == "Amsterdam")
        #expect(loc.coordinate.latitude == 52.37)
        #expect(loc.coordinate.longitude == 4.89)
    }

    @Test("init with nil name sets name to nil")
    func init_withoutName() {
        let loc = Location(name: nil, latitude: 0, longitude: 0)
        #expect(loc.name == nil)
    }

    @Test("displayName returns name when present")
    func displayName_withName() {
        let loc = Location(name: "Paris", latitude: 48.85, longitude: 2.35)
        #expect(loc.displayName == "Paris")
    }

    @Test("displayName returns Unknown when name is nil")
    func displayName_withoutName() {
        let loc = Location(name: nil, latitude: 0, longitude: 0)
        #expect(loc.displayName == LocalizationHelper.Location.unnamedLocation)
    }

    @Test("formattedCoordinates returns four decimal places")
    func formattedCoordinates() {
        let loc = Location(name: nil, latitude: 52.3676, longitude: 4.9041)
        #expect(loc.formattedCoordinates == "52.3676, 4.9041")
    }

    @Test("Equatable compares by id")
    func equatable() {
        let id = UUID()
        let a = Location(id: id, name: "A", latitude: 1, longitude: 2)
        let b = Location(id: id, name: "B", latitude: 3, longitude: 4)
        #expect(a == b)
        let c = Location(name: "A", latitude: 1, longitude: 2)
        #expect(a != c)
    }
}

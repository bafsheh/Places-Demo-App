//
//  Places_Demo_AppTests.swift
//  Places-Demo-AppTests
//

import Testing
import CoreLocation
@testable import Places_Demo_App

struct Places_Demo_AppTests {

    @Test func locationDTOToDomain() async throws {
        let dto = LocationDTO(name: "Amsterdam", lat: 52.35, long: 4.83)
        let location = dto.toDomain()
        #expect(location.name == "Amsterdam")
        #expect(location.coordinate.latitude == 52.35)
        #expect(location.coordinate.longitude == 4.83)
    }

    @Test func locationDTOOptionalName() async throws {
        let dto = LocationDTO(name: nil, lat: 0, long: 0)
        let location = dto.toDomain()
        #expect(location.name == nil)
        #expect(location.displayName == "Unknown")
    }

    @Test func locationFormattedCoordinates() async throws {
        let location = Location(name: "Test", latitude: 52.3547, longitude: 4.8339)
        #expect(location.formattedCoordinates == "52.3547, 4.8339")
    }
}

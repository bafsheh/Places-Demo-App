//
//  CoordinateMapperTests.swift
//  Places-Demo-AppTests
//

import CoreLocation
import Foundation
import Testing
@testable import Places_Demo_App

@MainActor
@Suite("CoordinateMapper toCoreLocation and toDomain roundtrip")
struct CoordinateMapperTests {

    @Test("toCoreLocation and toDomain roundtrip preserves coordinate values")
    func roundtrip() {
        let domain = Coordinate(latitude: 52.37, longitude: 4.89)
        let core = CoordinateMapper.toCoreLocation(domain)
        let back = CoordinateMapper.toDomain(core)
        #expect(back.latitude == domain.latitude)
        #expect(back.longitude == domain.longitude)
    }
}

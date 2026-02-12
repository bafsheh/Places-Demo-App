//
//  CoordinateTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("Coordinate init clamping and Equatable")
struct CoordinateTests {

    @Test("init clamps latitude to 90 when above 90")
    func init_clampsLatitudeHigh() {
        let c = Coordinate(latitude: 100, longitude: 0)
        #expect(c.latitude == 90)
    }

    @Test("init clamps latitude to -90 when below -90")
    func init_clampsLatitudeLow() {
        let c = Coordinate(latitude: -100, longitude: 0)
        #expect(c.latitude == -90)
    }

    @Test("init clamps longitude to 180 when above 180")
    func init_clampsLongitudeHigh() {
        let c = Coordinate(latitude: 0, longitude: 200)
        #expect(c.longitude == 180)
    }

    @Test("init clamps longitude to -180 when below -180")
    func init_clampsLongitudeLow() {
        let c = Coordinate(latitude: 0, longitude: -200)
        #expect(c.longitude == -180)
    }

    @Test("init keeps values within valid range unchanged")
    func init_validRange() {
        let c = Coordinate(latitude: 52.37, longitude: 4.89)
        #expect(c.latitude == 52.37)
        #expect(c.longitude == 4.89)
    }

    @Test("Equatable returns true for same latitude and longitude")
    func equatable() {
        let a = Coordinate(latitude: 1, longitude: 2)
        let b = Coordinate(latitude: 1, longitude: 2)
        #expect(a == b)
    }
}

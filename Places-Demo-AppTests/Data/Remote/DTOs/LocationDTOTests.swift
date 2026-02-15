//
//  LocationDTOTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@Suite("LocationDTO toDomain and Codable; LocationsResponse decode")
struct LocationDTOTests {

    @Test("LocationDTO decode from JSON with name maps toDomain correctly")
    func locationDTO_toDomain_withName() throws {
        let json = """
        {"name":"Amsterdam","lat":52.37,"long":4.89}
        """
        let data = json.data(using: .utf8)!
        let dto = try JSONDecoder().decode(LocationDTO.self, from: data)
        let location = dto.toDomain()
        #expect(location.name == "Amsterdam")
        #expect(abs(location.coordinate.latitude - 52.37) < 0.001)
        #expect(abs(location.coordinate.longitude - 4.89) < 0.001)
    }

    @Test("LocationDTO decode from JSON without name maps toDomain with nil name")
    func locationDTO_toDomain_withoutName() throws {
        let json = """
        {"lat":52.0,"long":5.0}
        """
        let data = json.data(using: .utf8)!
        let dto = try JSONDecoder().decode(LocationDTO.self, from: data)
        let location = dto.toDomain()
        #expect(location.name == nil)
        #expect(abs(location.coordinate.latitude - 52.0) < 0.001)
        #expect(abs(location.coordinate.longitude - 5.0) < 0.001)
    }

    @Test("LocationDTO encode roundtrip preserves data")
    func locationDTO_encodeRoundtrip() throws {
        let json = """
        {"name":"Paris","lat":48.85,"long":2.35}
        """
        let data = json.data(using: .utf8)!
        let dto = try JSONDecoder().decode(LocationDTO.self, from: data)
        let encoded = try JSONEncoder().encode(dto)
        let decoded = try JSONDecoder().decode(LocationDTO.self, from: encoded)
        #expect(decoded.name == dto.name)
        #expect(decoded.lat == dto.lat)
        #expect(decoded.long == dto.long)
    }

    @Test("LocationsResponse decode from valid JSON returns locations array")
    func locationsResponse_decode() throws {
        let json = """
        {"locations":[{"name":"A","lat":1.0,"long":2.0}]}
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
        #expect(response.locations.count == 1)
        #expect(response.locations[0].name == "A")
    }

    @Test("LocationsResponse decode from empty locations returns empty array")
    func locationsResponse_decodeEmpty() throws {
        let json = """
        {"locations":[]}
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
        #expect(response.locations.isEmpty)
    }

    @Test("LocationsResponse decode fails on malformed JSON")
    func locationsResponse_decodeFailure() {
        let json = """
        {"locations": "not an array"}
        """
        let data = json.data(using: .utf8)!
        do {
            _ = try JSONDecoder().decode(LocationsResponse.self, from: data)
            #expect(Bool(false), "Expected decode to throw")
        } catch {
            #expect(true)
        }
    }
}

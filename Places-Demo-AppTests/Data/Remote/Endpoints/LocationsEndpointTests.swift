//
//  LocationsEndpointTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@Suite("LocationsEndpoint path, method and urlRequest")
struct LocationsEndpointTests {

    @Test("path returns expected path for locations")
    func path() {
        #expect(LocationsEndpoint.locations.path == "/abnamrocoesd/assignment-ios/main/locations.json")
    }

    @Test("method is GET")
    func method() {
        #expect(LocationsEndpoint.locations.method == .get)
    }

    @Test("urlRequest with valid config returns URLRequest with correct URL method headers and timeout")
    func urlRequest_validConfig() throws {
        let config = NetworkConfiguration(
            baseURL: "https://api.example.com",
            headers: ["Accept": "application/json"],
            timeout: 60
        )
        let request = try LocationsEndpoint.locations.urlRequest(with: config)
        #expect(request.url?.absoluteString == "https://api.example.com/abnamrocoesd/assignment-ios/main/locations.json")
        #expect(request.httpMethod == "GET")
        #expect(request.timeoutInterval == 60)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test("urlRequest with invalid base URL throws invalidURL")
    func urlRequest_invalidURL() {
        let config = NetworkConfiguration(baseURL: "http://[::1", headers: [:], timeout: 30)
        do {
            _ = try LocationsEndpoint.locations.urlRequest(with: config)
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .invalidURL = error { } else {
                #expect(Bool(false), "Expected invalidURL, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }
}

//
//  MockNetworkService.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for NetworkServiceProtocol; returns configured LocationsResponse or throws.
//  Usage: Use in unit tests (e.g. RemoteDataSource) to avoid real HTTP.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `NetworkServiceProtocol`. Set `locationsResponse` or `errorToThrow`; only decodes to `LocationsResponse`.
final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {

    var locationsResponse: LocationsResponse?
    var errorToThrow: Error?

    init(locationsResponse: LocationsResponse? = nil, errorToThrow: Error? = nil) {
        self.locationsResponse = locationsResponse
        self.errorToThrow = errorToThrow
    }

    func request<T: Decodable & Sendable>(_ endpoint: EndpointProtocol) async throws -> T {
        if let errorToThrow {
            throw errorToThrow
        }
        guard let locationsResponse else {
            throw NSError(domain: "MockNetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response configured"])
        }
        guard T.self == LocationsResponse.self else {
            throw NSError(domain: "MockNetworkService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unsupported type \(T.self)"])
        }
        return locationsResponse as! T
    }
}

//
//  MockNetworkService.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock of `NetworkServiceProtocol` for unit tests. Configure success response or error to throw.
final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {

    var locationsResponse: LocationsResponse?
    var errorToThrow: Error?

    init(locationsResponse: LocationsResponse? = nil, errorToThrow: Error? = nil) {
        self.locationsResponse = locationsResponse
        self.errorToThrow = errorToThrow
    }

    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
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

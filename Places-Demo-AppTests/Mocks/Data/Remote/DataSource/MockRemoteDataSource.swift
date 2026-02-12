//
//  MockRemoteDataSource.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for RemoteDataSourceProtocol; returns configured DTOs or throws.
//  Usage: Use in unit tests (e.g. LocationRepository) to avoid network.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `RemoteDataSourceProtocol`. Set `locationsToReturn` or `errorToThrow` to control behavior.
final class MockRemoteDataSource: RemoteDataSourceProtocol, @unchecked Sendable {

    var locationsToReturn: [LocationDTO] = []
    var errorToThrow: Error?

    init(locationsToReturn: [LocationDTO] = [], errorToThrow: Error? = nil) {
        self.locationsToReturn = locationsToReturn
        self.errorToThrow = errorToThrow
    }

    func fetchLocations() async throws -> [LocationDTO] {
        if let errorToThrow {
            throw errorToThrow
        }
        return locationsToReturn
    }
}

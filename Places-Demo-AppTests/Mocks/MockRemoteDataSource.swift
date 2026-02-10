//
//  MockRemoteDataSource.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock of `RemoteDataSourceProtocol` for unit tests. Configure locations to return or error to throw.
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

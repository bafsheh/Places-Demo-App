//
//  MockFetchLocationsUseCase.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for FetchLocationsUseCaseProtocol; returns configured locations or throws.
//  Usage: Use in unit tests (e.g. LocationListViewModel) to avoid network.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `FetchLocationsUseCaseProtocol`. Set `locationsToReturn` or `errorToThrow` to control behavior.
final class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol, @unchecked Sendable {

    var locationsToReturn: [Location] = []
    var errorToThrow: Error?

    func execute() async throws -> [Location] {
        if let errorToThrow {
            throw errorToThrow
        }
        return locationsToReturn
    }
}

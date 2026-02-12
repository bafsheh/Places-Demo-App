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
/// Set `delayNanoseconds` to simulate slow network and observe loading state transitions.
final class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol, @unchecked Sendable {

    var locationsToReturn: [Location] = []
    var errorToThrow: Error?
    /// When set, execute() sleeps this many nanoseconds before returning; use to test loading state.
    var delayNanoseconds: UInt64?

    func execute() async throws -> [Location] {
        if let delayNanoseconds {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }
        if let errorToThrow {
            throw errorToThrow
        }
        return locationsToReturn
    }
}

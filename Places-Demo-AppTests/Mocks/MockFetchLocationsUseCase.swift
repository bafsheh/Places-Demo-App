//
//  MockFetchLocationsUseCase.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock FetchLocationsUseCase for tests. Returns configured locations or throws.
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

//
//  MockLocationRepository.swift
//  Places-Demo-AppTests
//
//  Test double for LocationRepositoryProtocol; use locationsToReturn / errorToThrow.
//

import Foundation
@testable import Places_Demo_App

final class MockLocationRepository: LocationRepositoryProtocol, @unchecked Sendable {
    var locationsToReturn: [Location] = []
    var errorToThrow: Error?

    func fetchLocations() async throws -> [Location] {
        if let errorToThrow {
            throw errorToThrow
        }
        return locationsToReturn
    }
}

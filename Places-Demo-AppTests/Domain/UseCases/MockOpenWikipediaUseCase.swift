//
//  MockOpenWikipediaUseCase.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock OpenWikipediaUseCase for tests. Records opened locations and can throw or succeed.
final class MockOpenWikipediaUseCase: OpenWikipediaUseCaseProtocol, @unchecked Sendable {

    var openedLocations: [Location] = []
    var errorToThrow: Error?

    func execute(location: Location) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
        openedLocations.append(location)
    }
}

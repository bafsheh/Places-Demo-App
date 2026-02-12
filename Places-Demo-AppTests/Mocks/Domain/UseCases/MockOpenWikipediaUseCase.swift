//
//  MockOpenWikipediaUseCase.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for OpenWikipediaUseCaseProtocol; records opened locations and can throw or succeed.
//  Usage: Use in unit tests (e.g. LocationListViewModel) to avoid opening real URLs.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `OpenWikipediaUseCaseProtocol`. Set `openedLocations` to inspect calls; `errorToThrow` to simulate failure.
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

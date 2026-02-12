//
//  MockWikipediaDeepLinkService.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for WikipediaDeepLinkServiceProtocol; records opened locations and can throw or succeed.
//  Usage: Use in unit tests (e.g. OpenWikipediaUseCase) to avoid opening real URLs.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `WikipediaDeepLinkServiceProtocol`. Set `openedLocations` to inspect calls; `errorToThrow` to simulate failure.
final class MockWikipediaDeepLinkService: WikipediaDeepLinkServiceProtocol, @unchecked Sendable {

    var openedLocations: [Location] = []
    var errorToThrow: Error?

    func openPlaces(at location: Location) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
        openedLocations.append(location)
    }
}

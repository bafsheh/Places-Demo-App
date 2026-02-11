//
//  MockWikipediaDeepLinkService.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock WikipediaDeepLinkService for tests. Records opened locations and can throw or succeed.
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

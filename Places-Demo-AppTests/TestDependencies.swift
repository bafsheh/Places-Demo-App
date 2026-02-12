//
//  TestDependencies.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Builds a `Dependencies` instance with mock use cases for tests.
/// All test-only wiring lives here; the main app has no test API.
/// Mocks may use `@unchecked Sendable` for test-only use and are not shared across actors.
@MainActor
enum TestDependencies {

    static func make(
        fetchLocations: any FetchLocationsUseCaseProtocol = MockFetchLocationsUseCase(),
        openWikipedia: any OpenWikipediaUseCaseProtocol = MockOpenWikipediaUseCase()
    ) -> Dependencies {
        Dependencies(
            fetchLocationsUseCase: fetchLocations,
            openWikipediaUseCase: openWikipedia
        )
    }
}

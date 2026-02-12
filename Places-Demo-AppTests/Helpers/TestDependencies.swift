//
//  TestDependencies.swift
//  Places-Demo-AppTests
//
//  Purpose: Test helper for creating Dependencies with mocks; simplifies test setup.
//  Dependencies: @testable Places_Demo_App, MockFetchLocationsUseCase, MockOpenWikipediaUseCase.
//  Usage: Use TestDependencies.make(), makeForLocationList(), or makeWithErrors() in tests.
//

import Foundation
@testable import Places_Demo_App

/// Test helper for creating Dependencies with mocks
///
/// Simplifies test setup by providing pre-configured mock dependencies.
/// All mocks use default behavior (success scenarios); customize as needed in tests.
///
/// # Example
/// ```swift
/// let deps = TestDependencies.make()
/// let viewModel = deps.makeLocationsListViewModel()
///
/// // Customize mock behavior
/// let mockFetch = deps.fetchLocationsUseCase as! MockFetchLocationsUseCase
/// mockFetch.locationsToReturn = [location1, location2]
/// ```
@MainActor
struct TestDependencies {

    /// Create Dependencies with all mocks using default behavior
    ///
    /// - Returns: Dependencies instance with mock use cases
    static func make() -> Dependencies {
        make(
            fetchLocationsUseCase: MockFetchLocationsUseCase(),
            openWikipediaUseCase: MockOpenWikipediaUseCase()
        )
    }

    /// Create Dependencies with custom mocks
    ///
    /// - Parameters:
    ///   - fetchLocationsUseCase: Custom mock for fetch locations (default: MockFetchLocationsUseCase())
    ///   - openWikipediaUseCase: Custom mock for open Wikipedia (default: MockOpenWikipediaUseCase())
    /// - Returns: Dependencies instance
    static func make(
        fetchLocationsUseCase: any FetchLocationsUseCaseProtocol = MockFetchLocationsUseCase(),
        openWikipediaUseCase: any OpenWikipediaUseCaseProtocol = MockOpenWikipediaUseCase()
    ) -> Dependencies {
        Dependencies(
            fetchLocationsUseCase: fetchLocationsUseCase,
            openWikipediaUseCase: openWikipediaUseCase
        )
    }

    /// Create Dependencies for testing LocationListViewModel success scenario (with default sample locations).
    ///
    /// Pre-configures mocks with `SampleData.locations`.
    ///
    /// - Returns: Dependencies with configured mocks
    static func makeForLocationList() -> (dependencies: Dependencies, fetchMock: MockFetchLocationsUseCase, openMock: MockOpenWikipediaUseCase) {
        makeForLocationList(locations: SampleData.locations)
    }

    /// Create Dependencies for testing LocationListViewModel success scenario with custom locations.
    ///
    /// - Parameter locations: Locations to return from fetch
    /// - Returns: Dependencies with configured mocks
    static func makeForLocationList(
        locations: [Location]
    ) -> (dependencies: Dependencies, fetchMock: MockFetchLocationsUseCase, openMock: MockOpenWikipediaUseCase) {
        let fetchMock = MockFetchLocationsUseCase()
        fetchMock.locationsToReturn = locations

        let openMock = MockOpenWikipediaUseCase()

        let deps = Dependencies(
            fetchLocationsUseCase: fetchMock,
            openWikipediaUseCase: openMock
        )

        return (deps, fetchMock, openMock)
    }

    /// Create Dependencies for testing error scenarios
    ///
    /// - Parameters:
    ///   - fetchError: Error to throw from fetch use case
    ///   - openError: Error to throw from open use case (optional)
    /// - Returns: Dependencies with error-configured mocks
    static func makeWithErrors(
        fetchError: Error? = nil,
        openError: Error? = nil
    ) -> Dependencies {
        let fetchMock = MockFetchLocationsUseCase()
        if let error = fetchError {
            fetchMock.errorToThrow = error
        }

        let openMock = MockOpenWikipediaUseCase()
        if let error = openError {
            openMock.errorToThrow = error
        }

        return Dependencies(
            fetchLocationsUseCase: fetchMock,
            openWikipediaUseCase: openMock
        )
    }
}

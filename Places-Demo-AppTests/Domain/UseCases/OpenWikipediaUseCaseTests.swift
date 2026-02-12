//
//  OpenWikipediaUseCaseTests.swift
//  Places-Demo-AppTests
//
//  Purpose: Unit tests for OpenWikipediaUseCase (execute success/failure via port).
//  Dependencies: @testable Places_Demo_App, OpenWikipediaUseCase, WikipediaDeepLinkAdapter, MockWikipediaDeepLinkService, Location, OpenWikipediaError, DeepLinkError.
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite
struct OpenWikipediaUseCaseTests {

    // MARK: - Fixtures

    private var sampleLocation: Location {
        Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89)
    }

    private func makeUseCase(deepLinkService: MockWikipediaDeepLinkService) -> OpenWikipediaUseCase {
        let adapter = WikipediaDeepLinkAdapter(deepLinkService: deepLinkService)
        return OpenWikipediaUseCase(port: adapter)
    }

    // MARK: - execute_success

    @Test
    func execute_success() async throws {
        // Given: MockWikipediaDeepLinkService succeeds
        let mockService = MockWikipediaDeepLinkService()
        let useCase = makeUseCase(deepLinkService: mockService)
        let location = sampleLocation

        // When: useCase.execute(location) called
        try await useCase.execute(location: location)

        // Then: No error thrown; service was called with correct location
        #expect(mockService.openedLocations.count == 1)
        let first = try #require(mockService.openedLocations.first)
        #expect(first.name == location.name)
        #expect(abs(first.coordinate.latitude - location.coordinate.latitude) < 0.001)
        #expect(abs(first.coordinate.longitude - location.coordinate.longitude) < 0.001)
    }

    // MARK: - execute_failure_urlCreation

    @Test
    func execute_failure_urlCreation() async {
        // Given: Service throws DeepLinkError.urlCreationFailed
        let mockService = MockWikipediaDeepLinkService()
        mockService.errorToThrow = DeepLinkError.urlCreationFailed
        let useCase = makeUseCase(deepLinkService: mockService)
        let location = sampleLocation

        // When: useCase.execute(location) called
        // Then: Error propagated (as OpenWikipediaError via adapter)
        do {
            try await useCase.execute(location: location)
            #expect(Bool(false), "Expected throw")
        } catch let error as OpenWikipediaError {
            if case .urlCreationFailed = error { } else {
                #expect(Bool(false), "Expected OpenWikipediaError.urlCreationFailed, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected OpenWikipediaError, got \(error)")
        }
    }

    // MARK: - execute_failure_appNotInstalled

    @Test
    func execute_failure_appNotInstalled() async {
        // Given: Service throws DeepLinkError.appNotInstalled
        let mockService = MockWikipediaDeepLinkService()
        mockService.errorToThrow = DeepLinkError.appNotInstalled(appName: "Wikipedia")
        let useCase = makeUseCase(deepLinkService: mockService)
        let location = sampleLocation

        // When: useCase.execute(location) called
        // Then: Error propagated with message
        do {
            try await useCase.execute(location: location)
            #expect(Bool(false), "Expected throw")
        } catch let error as OpenWikipediaError {
            if case .appNotInstalled(let name) = error {
                #expect(name == "Wikipedia")
            } else {
                #expect(Bool(false), "Expected OpenWikipediaError.appNotInstalled, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected OpenWikipediaError, got \(error)")
        }
    }
}

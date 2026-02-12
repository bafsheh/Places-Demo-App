//
//  OpenWikipediaUseCaseTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("OpenWikipediaUseCase execute via port adapter")
struct OpenWikipediaUseCaseTests {

    private var sampleLocation: Location {
        Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89)
    }

    private func makeUseCase(deepLinkService: MockWikipediaDeepLinkService) -> OpenWikipediaUseCase {
        let adapter = WikipediaDeepLinkAdapter(deepLinkService: deepLinkService)
        return OpenWikipediaUseCase(port: adapter)
    }

    @Test("execute succeeds and calls service with correct location when service succeeds")
    func execute_success() async throws {
        let mockService = MockWikipediaDeepLinkService()
        let useCase = makeUseCase(deepLinkService: mockService)
        let location = sampleLocation

        try await useCase.execute(location: location)

        #expect(mockService.openedLocations.count == 1)
        let first = try #require(mockService.openedLocations.first)
        #expect(first.name == location.name)
        #expect(abs(first.coordinate.latitude - location.coordinate.latitude) < 0.001)
        #expect(abs(first.coordinate.longitude - location.coordinate.longitude) < 0.001)
    }

    @Test("execute throws urlCreationFailed when service throws urlCreationFailed")
    func execute_failure_urlCreation() async {
        let mockService = MockWikipediaDeepLinkService()
        mockService.errorToThrow = DeepLinkError.urlCreationFailed
        let useCase = makeUseCase(deepLinkService: mockService)
        let location = sampleLocation

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

    @Test("execute throws appNotInstalled when service throws appNotInstalled")
    func execute_failure_appNotInstalled() async {
        let mockService = MockWikipediaDeepLinkService()
        mockService.errorToThrow = DeepLinkError.appNotInstalled(appName: "Wikipedia")
        let useCase = makeUseCase(deepLinkService: mockService)
        let location = sampleLocation

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

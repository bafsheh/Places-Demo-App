//
//  FetchLocationsUseCaseTests.swift
//  Places-Demo-AppTests
//
//  Purpose: Unit tests for FetchLocationsUseCase (execute success/failure via repository).
//  Dependencies: @testable Places_Demo_App, FetchLocationsUseCase, LocationRepositoryProtocol, Location, Mock (repository).
//

import Testing
@testable import Places_Demo_App

/// Mock repository for FetchLocationsUseCase tests; use locationsToReturn / errorToThrow.
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

@MainActor
@Suite
struct FetchLocationsUseCaseTests {

    // MARK: - execute_success

    @Test
    func execute_success() async throws {
        // Given: MockLocationRepository returns 3 locations
        let locations = [
            Location(name: "A", latitude: 52.0, longitude: 4.0),
            Location(name: "B", latitude: 52.1, longitude: 4.1),
            Location(name: "C", latitude: 52.2, longitude: 4.2)
        ]
        let mockRepo = MockLocationRepository()
        mockRepo.locationsToReturn = locations
        let useCase = FetchLocationsUseCase(repository: mockRepo)

        // When: useCase.execute() called
        let result = try await useCase.execute()

        // Then: Returns 3 locations; no error thrown
        #expect(result.count == 3)
        #expect(result.map { $0.name } == ["A", "B", "C"])
    }

    // MARK: - execute_failure

    @Test
    func execute_failure() async {
        // Given: MockLocationRepository throws error
        let mockRepo = MockLocationRepository()
        mockRepo.errorToThrow = NetworkError.noData
        let useCase = FetchLocationsUseCase(repository: mockRepo)

        // When: useCase.execute() called
        // Then: Error is propagated; error type matches
        do {
            _ = try await useCase.execute()
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .noData = error { } else {
                #expect(Bool(false), "Expected NetworkError.noData, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }
}

//
//  FetchLocationsUseCaseTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@Suite("FetchLocationsUseCase execute via repository")
struct FetchLocationsUseCaseTests {

    @Test("execute returns locations from repository when repository returns array")
    func execute_success() async throws {
        let locations = [
            Location(name: "A", latitude: 52.0, longitude: 4.0),
            Location(name: "B", latitude: 52.1, longitude: 4.1),
            Location(name: "C", latitude: 52.2, longitude: 4.2)
        ]
        let mockRepo = MockLocationRepository()
        mockRepo.locationsToReturn = locations
        let useCase = FetchLocationsUseCase(repository: mockRepo)

        let result = try await useCase.execute()

        #expect(result.count == 3)
        #expect(result.map { $0.name } == ["A", "B", "C"])
    }

    @Test("execute throws when repository throws domain error")
    func execute_failure() async {
        let mockRepo = MockLocationRepository()
        mockRepo.errorToThrow = LocationFetchError.networkUnavailable
        let useCase = FetchLocationsUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute()
            #expect(Bool(false), "Expected throw")
        } catch let error as LocationFetchError {
            if case .networkUnavailable = error { } else {
                #expect(Bool(false), "Expected LocationFetchError.networkUnavailable, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected LocationFetchError, got \(error)")
        }
    }
}

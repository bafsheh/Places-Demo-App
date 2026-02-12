//
//  LocationRepositoryTests.swift
//  Places-Demo-AppTests
//
//  Purpose: Unit tests for LocationRepository (fetch from data source, DTO → domain mapping).
//  Dependencies: @testable Places_Demo_App, LocationRepository, MockRemoteDataSource, LocationDTO, Location, NetworkError.
//

import Foundation
import Testing
@testable import Places_Demo_App

@MainActor
@Suite
struct LocationRepositoryTests {

    // MARK: - Fixtures

    private func makeDTOs() -> [LocationDTO] {
        let json = """
        [{"name":"Amsterdam","lat":52.37,"long":4.89},{"name":"Rotterdam","lat":51.92,"long":4.48},{"lat":52.0,"long":5.0}]
        """
        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode([LocationDTO].self, from: data)
    }

    // MARK: - fetchLocations_success_mapsDTO

    @Test
    func fetchLocations_success_mapsDTO() async throws {
        // Given: MockRemoteDataSource returns LocationDTO array
        let dtos = makeDTOs()
        let mockDataSource = MockRemoteDataSource(locationsToReturn: dtos)
        let repository = LocationRepository(remoteDataSource: mockDataSource)

        // When: repository.fetchLocations() called
        let result = try await repository.fetchLocations()

        // Then: Returns Location array (domain models); DTO → Domain mapping correct
        #expect(result.count == 3)
        let r0 = result[0], r1 = result[1], r2 = result[2]
        #expect(r0.name == "Amsterdam")
        #expect(abs(r0.coordinate.latitude - 52.37) < 0.001)
        #expect(abs(r0.coordinate.longitude - 4.89) < 0.001)
        #expect(r1.name == "Rotterdam")
        #expect(abs(r1.coordinate.latitude - 51.92) < 0.001)
        #expect(abs(r1.coordinate.longitude - 4.48) < 0.001)
        #expect(r2.name == nil)
        #expect(abs(r2.coordinate.latitude - 52.0) < 0.001)
        #expect(abs(r2.coordinate.longitude - 5.0) < 0.001)
    }

    // MARK: - fetchLocations_failure

    @Test
    func fetchLocations_failure() async {
        // Given: MockRemoteDataSource throws NetworkError
        let mockDataSource = MockRemoteDataSource(errorToThrow: NetworkError.noData)
        let repository = LocationRepository(remoteDataSource: mockDataSource)

        // When: repository.fetchLocations() called
        // Then: Error propagated
        do {
            _ = try await repository.fetchLocations()
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .noData = error { } else {
                #expect(Bool(false), "Expected NetworkError.noData, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }

    // MARK: - fetchLocations_emptyArray

    @Test
    func fetchLocations_emptyArray() async throws {
        // Given: MockRemoteDataSource returns []
        let mockDataSource = MockRemoteDataSource(locationsToReturn: [])
        let repository = LocationRepository(remoteDataSource: mockDataSource)

        // When: repository.fetchLocations() called
        let result = try await repository.fetchLocations()

        // Then: Returns empty array; no error
        #expect(result.isEmpty)
    }
}

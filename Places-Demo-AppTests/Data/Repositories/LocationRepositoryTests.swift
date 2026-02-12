//
//  LocationRepositoryTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@MainActor
@Suite("LocationRepository fetch from data source and DTO to domain mapping")
struct LocationRepositoryTests {

    private func makeDTOs() -> [LocationDTO] {
        let json = """
        [{"name":"Amsterdam","lat":52.37,"long":4.89},{"name":"Rotterdam","lat":51.92,"long":4.48},{"lat":52.0,"long":5.0}]
        """
        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode([LocationDTO].self, from: data)
    }

    @Test("fetchLocations returns domain locations with correct mapping from DTOs")
    func fetchLocations_success_mapsDTO() async throws {
        let dtos = makeDTOs()
        let mockDataSource = MockRemoteDataSource(locationsToReturn: dtos)
        let repository = LocationRepository(remoteDataSource: mockDataSource)

        let result = try await repository.fetchLocations()

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

    @Test("fetchLocations throws when data source throws")
    func fetchLocations_failure() async {
        let mockDataSource = MockRemoteDataSource(errorToThrow: NetworkError.noData)
        let repository = LocationRepository(remoteDataSource: mockDataSource)

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

    @Test("fetchLocations returns empty array when data source returns empty")
    func fetchLocations_emptyArray() async throws {
        let mockDataSource = MockRemoteDataSource(locationsToReturn: [])
        let repository = LocationRepository(remoteDataSource: mockDataSource)

        let result = try await repository.fetchLocations()

        #expect(result.isEmpty)
    }
}

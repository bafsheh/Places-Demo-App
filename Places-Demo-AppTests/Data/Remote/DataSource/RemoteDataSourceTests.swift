//
//  RemoteDataSourceTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@MainActor
@Suite("RemoteDataSource fetchLocations via NetworkService")
struct RemoteDataSourceTests {

    @Test("fetchLocations returns DTOs from mock network service response")
    func fetchLocations_success() async throws {
        let json = """
        {"locations":[{"name":"A","lat":52.0,"long":4.0},{"name":"B","lat":53.0,"long":5.0}]}
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
        let mockNetwork = MockNetworkService(locationsResponse: response)
        let dataSource = RemoteDataSource(networkService: mockNetwork)

        let result = try await dataSource.fetchLocations()

        #expect(result.count == 2)
        #expect(result[0].name == "A")
        #expect(result[0].lat == 52.0)
        #expect(result[1].name == "B")
    }

    @Test("fetchLocations throws when network service throws")
    func fetchLocations_failure() async {
        let mockNetwork = MockNetworkService(errorToThrow: NetworkError.noData)
        let dataSource = RemoteDataSource(networkService: mockNetwork)

        do {
            _ = try await dataSource.fetchLocations()
            #expect(Bool(false), "Expected throw")
        } catch let error as NetworkError {
            if case .noData = error { } else {
                #expect(Bool(false), "Expected noData, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected NetworkError, got \(error)")
        }
    }
}

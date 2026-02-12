import Foundation

/// Protocol for remote data fetching. Implementations typically call a network service and map DTOs.
protocol RemoteDataSourceProtocol: Sendable {

    /// Fetches locations from the remote API.
    /// - Returns: Array of location DTOs.
    func fetchLocations() async throws -> [LocationDTO]
}

import Foundation

/// Protocol defining the contract for locations data access
protocol LocationsRepositoryProtocol: Sendable {

    /// Fetches locations from the remote source
    /// - Returns: Array of Location entities
    /// - Throws: NetworkError if the fetch fails
    func fetchLocations() async throws -> [Location]
}

import Foundation

/// Protocol for fetching locations. Allows injection of mocks in tests and alternate implementations.
protocol FetchLocationsUseCaseProtocol: Sendable {
    /// Executes the use case to fetch locations.
    func execute() async throws -> [Location]
}

/// Use case responsible for fetching locations.
final class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {

    private let repository: LocationsRepositoryProtocol

    init(repository: LocationsRepositoryProtocol) {
        self.repository = repository
    }

    /// Executes the use case to fetch locations
    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}

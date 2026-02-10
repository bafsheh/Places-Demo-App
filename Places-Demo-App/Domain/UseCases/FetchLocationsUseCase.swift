import Foundation

/// Use case responsible for fetching locations
final class FetchLocationsUseCase: Sendable {

    private let repository: LocationsRepositoryProtocol

    init(repository: LocationsRepositoryProtocol) {
        self.repository = repository
    }

    /// Executes the use case to fetch locations
    func execute() async throws -> [Location] {
        try await repository.fetchLocations()
    }
}

import Foundation

/// Implementation of LocationsRepositoryProtocol
final class LocationRepository: LocationsRepositoryProtocol {

    private let remoteDataSource: RemoteDataSourceProtocol

    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchLocations() async throws -> [Location] {
        let dtos = try await remoteDataSource.fetchLocations()
        return dtos.map { $0.toDomain() }
    }
}

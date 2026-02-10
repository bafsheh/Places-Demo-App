import Foundation
import UIKit

@MainActor
enum DependencyContainer {

    private static let networkConfiguration = NetworkConfiguration.default
    private static let networkService: NetworkServiceProtocol = NetworkService(
        configuration: networkConfiguration
    )
    private static let remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(
        networkService: networkService,
        configuration: networkConfiguration
    )
    private static let locationRepository: LocationsRepositoryProtocol = LocationRepository(
        remoteDataSource: remoteDataSource
    )

    static let fetchLocationsUseCase = FetchLocationsUseCase(
        repository: locationRepository
    )

    static func makeLocationsListViewModel() -> LocationListViewModel {
        LocationListViewModel(
            fetchLocationsUseCase: fetchLocationsUseCase
        )
    }
}

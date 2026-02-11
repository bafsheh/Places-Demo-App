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
    private static let urlOpener: URLOpening = DefaultURLOpener()
    private static let deepLinkService: DeepLinkServiceProtocol = DeepLinkService(urlOpener: urlOpener)
    private static let wikipediaDeepLinkService: WikipediaDeepLinkServiceProtocol = WikipediaDeepLinkService(
        deepLinkService: deepLinkService
    )

    static let fetchLocationsUseCase = FetchLocationsUseCase(
        repository: locationRepository
    )
    static let openWikipediaUseCase = OpenWikipediaUseCase(
        deepLinkService: wikipediaDeepLinkService
    )

    static func makeLocationsListViewModel() -> LocationListViewModel {
        LocationListViewModel(
            fetchLocationsUseCase: fetchLocationsUseCase,
            openWikipediaUseCase: openWikipediaUseCase
        )
    }
}

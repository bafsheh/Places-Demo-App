import Foundation
import UIKit

/// Holds protocol-typed dependencies so screens and tests can use the same resolution API.
/// Use `DependencyContainer.live` in the app and `DependencyContainer.test(fetchLocations:openWikipedia:)` in tests.
struct Dependencies: Sendable {

    let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    let openWikipediaUseCase: OpenWikipediaUseCaseProtocol

    func makeLocationsListViewModel() -> LocationListViewModel {
        LocationListViewModel(
            fetchLocationsUseCase: fetchLocationsUseCase,
            openWikipediaUseCase: openWikipediaUseCase
        )
    }
}

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

    private static let fetchLocationsUseCase: FetchLocationsUseCaseProtocol = FetchLocationsUseCase(
        repository: locationRepository
    )
    private static let openWikipediaUseCase: OpenWikipediaUseCaseProtocol = OpenWikipediaUseCase(
        deepLinkService: wikipediaDeepLinkService
    )

    /// Live dependencies (production implementations). Use in the app entry point.
    static let live = Dependencies(
        fetchLocationsUseCase: fetchLocationsUseCase,
        openWikipediaUseCase: openWikipediaUseCase
    )

    /// Test dependencies with injected use cases. Use in unit tests to provide mocks.
    static func test(
        fetchLocations: FetchLocationsUseCaseProtocol,
        openWikipedia: OpenWikipediaUseCaseProtocol
    ) -> Dependencies {
        Dependencies(
            fetchLocationsUseCase: fetchLocations,
            openWikipediaUseCase: openWikipedia
        )
    }

    /// Builds the locations list ViewModel using live dependencies. Prefer `DependencyContainer.live.makeLocationsListViewModel()` for new code.
    static func makeLocationsListViewModel() -> LocationListViewModel {
        live.makeLocationsListViewModel()
    }
}

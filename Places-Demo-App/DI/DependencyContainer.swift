import Foundation
import SwiftUI
import UIKit

// All app dependency resolution goes through DependencyContainer.live in production;
// tests use a Dependencies instance built in the test target (e.g. TestDependencies.make()).

/// Protocol for app dependency injection. MainActor-isolated so view factories run on the main actor (Swift 6).
@MainActor
protocol AppDependenciesProtocol {

    func makeRootView(router: Router<PlacesRoute>) -> LocationListView
    func makeLocationsListViewModel() -> LocationListViewModel
    func makeAddLocationViewModel(onSubmit: @escaping (Location) -> Void) -> AddLocationViewModel
}

/// Holds protocol-typed dependencies. Conforms to AppDependenciesProtocol for injection into views.
struct Dependencies: Sendable, AppDependenciesProtocol {

    let fetchLocationsUseCase: any FetchLocationsUseCaseProtocol
    let openWikipediaUseCase: any OpenWikipediaUseCaseProtocol

    @MainActor
    func makeLocationsListViewModel() -> LocationListViewModel {
        LocationListViewModel(
            fetchLocationsUseCase: fetchLocationsUseCase,
            openWikipediaUseCase: openWikipediaUseCase
        )
    }

    @MainActor
    func makeRootView(router: Router<PlacesRoute>) -> LocationListView {
        LocationListView(router: router, viewModel: makeLocationsListViewModel(), dependencies: self)
    }

    @MainActor
    func makeAddLocationViewModel(onSubmit: @escaping (Location) -> Void) -> AddLocationViewModel {
        AddLocationViewModel(onSubmit: onSubmit)
    }
}

// MARK: - Container

@MainActor
enum DependencyContainer {

    // MARK: - Network

    private static let networkConfiguration = NetworkConfiguration.default
    private static let networkService: NetworkServiceProtocol = NetworkService(
        configuration: networkConfiguration
    )
    private static let remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(
        networkService: networkService,
        configuration: networkConfiguration
    )

    // MARK: - Domain (use cases)

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

    // MARK: - Presentation (Dependencies)

    /// Live dependencies (production). Use in the app entry point; tests use a Dependencies built in the test target (e.g. TestDependencies.make()).
    static let live = Dependencies(
        fetchLocationsUseCase: fetchLocationsUseCase,
        openWikipediaUseCase: openWikipediaUseCase
    )
}

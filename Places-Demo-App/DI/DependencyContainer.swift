//
//  DependencyContainer.swift
//  Places-Demo-App
//
//  Purpose: Central dependency injection; defines app dependencies and builds the live graph.
//  Dependencies: All data/domain/presentation types used by the app.
//  Usage: Production uses DependencyContainer.live; tests inject a Dependencies instance.
//

import Foundation
import SwiftUI
import UIKit

/// Protocol for app dependency injection; isolated to main actor so view/view model factories run on the main thread (Swift 6).
///
/// Implementations provide the root view and view model factories. Production uses `DependencyContainer.live`; tests build a `Dependencies` in the test target.
@MainActor
protocol AppDependenciesProtocol: Sendable {

    /// Builds the root list view with the given router and this dependencies instance (for sheet factory). Call from main actor (e.g. SwiftUI body).
    func makeRootView(router: Router<PlacesRoute>) -> LocationListView

    /// Builds the view model for the locations list (load, add, open Wikipedia). Call from main actor.
    func makeLocationsListViewModel() -> LocationListViewModel

    /// Builds the view model for the add-location sheet. Call from main actor.
    func makeAddLocationViewModel(onComplete: @escaping (Location?) -> Void) -> AddLocationViewModel
}

/// Holds protocol-typed use cases and conforms to `AppDependenciesProtocol` for injection into views.
///
/// Built by `DependencyContainer.live` in production; tests can construct a `Dependencies` with mock use cases. Protocol is `@MainActor` so view/view model creation runs on the main thread when called from SwiftUI.
struct Dependencies: Sendable, AppDependenciesProtocol {

    let fetchLocationsUseCase: any FetchLocationsUseCaseProtocol
    let openWikipediaUseCase: any OpenWikipediaUseCaseProtocol

    func makeLocationsListViewModel() -> LocationListViewModel {
        LocationListViewModel(
            fetchLocationsUseCase: fetchLocationsUseCase,
            openWikipediaUseCase: openWikipediaUseCase
        )
    }

    func makeRootView(router: Router<PlacesRoute>) -> LocationListView {
        LocationListView(router: router, viewModel: makeLocationsListViewModel(), dependencies: self)
    }

    func makeAddLocationViewModel(onComplete: @escaping (Location?) -> Void) -> AddLocationViewModel {
        AddLocationViewModel(onComplete: onComplete)
    }
}

// MARK: - Container

/// Static container that builds the live dependency graph for production.
///
/// Composes network, repository, deep link adapter, and use case layers; exposes `live` as the single `Dependencies` instance.
/// Wikipedia flow: `WikipediaDeepLinkService` is wrapped in `WikipediaDeepLinkAdapter` (implements `OpenWikipediaAtLocationPort`), then injected into `OpenWikipediaUseCase`. Tests build their own `Dependencies` with mocks.
enum DependencyContainer {

    // MARK: - Network

    private static let networkConfiguration = NetworkConfiguration.default
    private static let networkService: NetworkServiceProtocol = NetworkService(
        configuration: networkConfiguration
    )
    private static let remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(
        networkService: networkService
    )
    private static let locationRepository: LocationRepositoryProtocol = LocationRepository(
        remoteDataSource: remoteDataSource
    )
    private static let fetchLocationsUseCase: FetchLocationsUseCaseProtocol = FetchLocationsUseCase(
        repository: locationRepository
    )

    // MARK: - Presentation (Dependencies)

    /// Live dependencies for production; use in the app entry point (e.g. `MainNavigationView()`). Can be built off the main actor; only factory methods that create views/VMs require main.
    static let live: Dependencies = {
        let urlOpener: URLOpening = DefaultURLOpener()
        let deepLinkService = DeepLinkService(urlOpener: urlOpener)
        let wikipediaDeepLinkService = WikipediaDeepLinkService(deepLinkService: deepLinkService)
        let openWikipediaPort: OpenWikipediaAtLocationPort = WikipediaDeepLinkAdapter(
            deepLinkService: wikipediaDeepLinkService
        )
        let openWikipediaUseCase = OpenWikipediaUseCase(port: openWikipediaPort)
        return Dependencies(
            fetchLocationsUseCase: fetchLocationsUseCase,
            openWikipediaUseCase: openWikipediaUseCase
        )
    }()
}

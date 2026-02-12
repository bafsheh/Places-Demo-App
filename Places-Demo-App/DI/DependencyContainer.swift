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

/// Protocol for app dependency injection; view factories run on the main actor (Swift 6).
///
/// Implementations provide the root view and view model factories so the app and tests can use different dependency graphs. Production uses `DependencyContainer.live`; tests build a `Dependencies` (or test double) in the test target.
///
/// - SeeAlso: `Dependencies`, `DependencyContainer`, `RootView`, `LocationListView`
@MainActor
protocol AppDependenciesProtocol {

    /// Builds the root list view with the given router and this dependencies instance (for sheet factory).
    ///
    /// - Parameter router: App router for navigation and sheet presentation.
    /// - Returns: The main locations list view configured with a view model and this factory.
    func makeRootView(router: Router<PlacesRoute>) -> LocationListView

    /// Builds the view model for the locations list (load, add, open Wikipedia).
    ///
    /// - Returns: A new `LocationListViewModel` using the injected use cases.
    func makeLocationsListViewModel() -> LocationListViewModel

    /// Builds the view model for the add-location sheet.
    ///
    /// - Parameter continuation: Resumed once with the submitted `Location` on valid submit, or `nil` when the user cancels/dismisses.
    /// - Returns: A new `AddLocationViewModel` that will complete the continuation.
    func makeAddLocationViewModel(continuation: CheckedContinuation<Location?, Never>) -> AddLocationViewModel
}

/// Holds protocol-typed use cases and conforms to `AppDependenciesProtocol` for injection into views.
///
/// Built by `DependencyContainer.live` in production; tests can construct a `Dependencies` with mock use cases (e.g. `TestDependencies.make()`). MainActor methods ensure view creation runs on the main thread.
///
/// - SeeAlso: `AppDependenciesProtocol`, `DependencyContainer`, `FetchLocationsUseCaseProtocol`, `OpenWikipediaUseCaseProtocol`
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
    func makeAddLocationViewModel(continuation: CheckedContinuation<Location?, Never>) -> AddLocationViewModel {
        AddLocationViewModel(continuation: continuation)
    }
}

// MARK: - Container

/// Static container that builds the live dependency graph for production.
///
/// Composes network, repository, deep link, and use case layers; exposes `live` as the single `Dependencies` instance. Tests do not use this; they build their own `Dependencies` with mocks.
///
/// - SeeAlso: `Dependencies`, `AppDependenciesProtocol`, `FetchLocationsUseCase`, `OpenWikipediaUseCase`, `LocationRepository`
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

    private static let locationRepository: LocationRepositoryProtocol = LocationRepository(
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

    /// Live dependencies for production; use in the app entry point (e.g. `RootView()` which uses this internally). Tests use a `Dependencies` built in the test target (e.g. `TestDependencies.make()`).
    static let live = Dependencies(
        fetchLocationsUseCase: fetchLocationsUseCase,
        openWikipediaUseCase: openWikipediaUseCase
    )
}

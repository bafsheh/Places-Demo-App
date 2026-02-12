//
//  LocationListViewModel.swift
//  Places-Demo-App
//
//  Purpose: View model for the locations list: load, add location, open in Wikipedia; drives ViewState.
//  Dependencies: FetchLocationsUseCaseProtocol, OpenWikipediaUseCaseProtocol, ViewState, Location.
//  Usage: Created by Dependencies.makeLocationsListViewModel; owned by LocationListView.
//

import Foundation
import Observation

/// View model for the locations list: load locations, add custom location, open in Wikipedia; drives `ViewState`.
///
/// Owns the list of locations in memory after load; updates `state` for idle/loading/loaded/error. Used by `LocationListView`; created by `Dependencies.makeLocationsListViewModel`.
///
/// - SeeAlso: `ViewState`, `FetchLocationsUseCaseProtocol`, `OpenWikipediaUseCaseProtocol`, `LocationListView`
@MainActor
@Observable
final class LocationListViewModel {

    // MARK: - Properties

    /// Current UI state (idle, loading, loaded list, or error message). Read by the view to show loading/list/error.
    private(set) var state: ViewState<[Location]> = .idle

    private let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    private let openWikipediaUseCase: OpenWikipediaUseCaseProtocol

    /// In-memory list of locations (fetched + user-added); backing for `state == .loaded(...)`.
    private var locationList: [Location] = []

    // MARK: - Lifecycle

    /// Creates the view model with the given use cases.
    ///
    /// - Parameters:
    ///   - fetchLocationsUseCase: Use case to load locations from the repository.
    ///   - openWikipediaUseCase: Use case to open Wikipedia at a location.
    init(
        fetchLocationsUseCase: FetchLocationsUseCaseProtocol,
        openWikipediaUseCase: OpenWikipediaUseCaseProtocol
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.openWikipediaUseCase = openWikipediaUseCase
    }

    // MARK: - Public Methods

    /// Loads locations from the repository and updates `state` to loading then loaded or error.
    ///
    /// Call on appear and from retry button; errors are surfaced as `state = .error(message)`.
    func loadLocations() async {
        state = .loading

        do {
            locationList = try await fetchLocationsUseCase.execute()
            state = .loaded(locationList)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    /// Appends a user-added location to the list and updates `state` to loaded with the new list.
    ///
    /// - Parameter location: The location to add (e.g. from the add-location sheet).
    func addLocation(_ location: Location) {
        locationList.append(location)
        state = .loaded(locationList)
    }

    /// Opens Wikipedia at the given location; on failure updates `state` to error.
    ///
    /// - Parameter location: The location to show in Wikipedia Places.
    func openLocation(_ location: Location) async {
        do {
            try await openWikipediaUseCase.execute(location: location)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

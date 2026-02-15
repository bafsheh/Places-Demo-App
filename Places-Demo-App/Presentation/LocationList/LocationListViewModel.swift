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
@MainActor
@Observable
final class LocationListViewModel {

    // MARK: - Properties

    /// Current UI state (idle, loading, loaded list, or error message). Read by the view to show loading/list/error.
    private(set) var state: ViewState<[Location]> = .idle

    private let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    private let openWikipediaUseCase: OpenWikipediaUseCaseProtocol

    /// In-memory list of all locations (fetched + user-added); backing for `state == .loaded(...)`.
    private var locationList: [Location] = []

    /// Locations added by the user that should survive reloads from the API.
    private var userAddedLocations: [Location] = []

    /// Current load task; cancelled when a new load starts to prevent stale results.
    private var loadTask: Task<Void, Never>?

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
    /// Cancels any in-flight load before starting a new one. `CancellationError` is silently ignored
    /// so that a cancelled load does not flash an error to the user.
    /// Call on appear and from retry button; errors are surfaced as `state = .error(error:message:)`.
    func loadLocations() async {
        loadTask?.cancel()
        state = .loading

        let task = Task {
            do {
                let locations = try await fetchLocationsUseCase.execute()
                guard !Task.isCancelled else { return }
                locationList = locations + userAddedLocations
                state = .loaded(locationList)
            } catch is CancellationError {
                // Silently ignore — another load replaced this one.
            } catch {
                guard !Task.isCancelled else { return }
                await Logger.shared.log(error: error, context: "LocationListViewModel.loadLocations")
                state = .error(error: error, message: Self.userFacingMessage(for: error))
            }
        }
        loadTask = task
        await task.value
        if loadTask == task { loadTask = nil }
    }

    /// Appends a user-added location to the list and updates `state` to loaded with the new list.
    ///
    /// - Parameter location: The location to add (e.g. from the add-location sheet).
    func addLocation(_ location: Location) {
        userAddedLocations.append(location)
        locationList.append(location)
        state = .loaded(locationList)
    }

    // MARK: - Private

    private static func userFacingMessage(for error: Error) -> String {
        switch error {
        case is NetworkError:
            return LocalizationHelper.Common.networkError
        case is OpenWikipediaError:
            return error.localizedDescription
        default:
            return LocalizationHelper.Common.genericError
        }
    }

    /// Opens Wikipedia at the given location; on failure updates `state` to error.
    ///
    /// - Parameter location: The location to show in Wikipedia Places.
    func openLocation(_ location: Location) async {
        do {
            try await openWikipediaUseCase.execute(location: location)
        } catch {
            await Logger.shared.log(error: error, context: "LocationListViewModel.openLocation")
            state = .error(error: error, message: Self.userFacingMessage(for: error))
        }
    }
}

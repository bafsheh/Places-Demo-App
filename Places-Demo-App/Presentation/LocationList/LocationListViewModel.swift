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

    /// Error to show in an alert when opening Wikipedia fails (e.g. app not installed). Does not replace the list.
    private(set) var openLocationError: OpenWikipediaError?

    /// Current load task; cancelled when a new load is started so the previous request is ended.
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
    /// Cancels any in-flight load so only the latest request applies; call on appear and from retry button.
    func loadLocations() async {
        loadTask?.cancel()

        let task = Task { @MainActor in
            state = .loading
            do {
                let list = try await fetchLocationsUseCase.execute()
                guard !Task.isCancelled else { return }

                locationList = list + userAddedLocations
                state = .loaded(locationList)
            } catch is CancellationError {
                // Ignore; another load was started.
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error: ViewStateError(describing: error), message: Self.userFacingMessage(for: error))
            }
        }

        loadTask = task
        await task.value

        if loadTask == task {
            loadTask = nil
        }
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

    /// Opens Wikipedia at the given location; on failure sets `openLocationError` (shown as alert) and keeps `state` unchanged.
    ///
    /// - Parameter location: The location to show in Wikipedia Places.
    func openLocation(_ location: Location) async {
        do {
            try await openWikipediaUseCase.execute(location: location)
        } catch {
            openLocationError = error as? OpenWikipediaError ?? .cannotOpenURL
        }
    }

    /// Clears the open-in-Wikipedia error (e.g. when user dismisses the alert).
    func dismissOpenLocationError() {
        openLocationError = nil
    }
}

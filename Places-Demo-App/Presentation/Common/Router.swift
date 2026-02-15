//
//  Router.swift
//  Places-Demo-App
//
//  Purpose: App routes and generic router for NavigationStack path and sheet presentation.
//  Dependencies: Observation.
//  Usage: Router<PlacesRoute> owned by MainNavigationView; passed to LocationListView and destination views.
//

import Foundation
import Observation

/// App-specific route enum for navigation (push and sheet destinations).
///
/// Add cases (e.g. `locationDetail(Location)`) when adding new screens; use with Router; push destinations can be added via navigationDestination when new route cases exist.
///
enum PlacesRoute: Hashable, Identifiable {

    /// Presents the add-location sheet (e.g. from toolbar button).
    case addLocation

    /// Stable identifier for SwiftUI list and navigation; defaults to `self`.
    var id: Self { self }
}

/// Generic router for NavigationStack path and presented sheet.
///
/// Holds the navigation path (push stack) and the currently presented sheet route. Reusable for any `Route` that is `Hashable` and `Identifiable`. Used with `PlacesRoute` in this app.
///
@MainActor
@Observable
final class Router<Route: Hashable & Identifiable> {

    /// Current navigation stack (push destinations). Bind to `NavigationStack(path:)`.
    var path: [Route] = []

    /// Currently presented sheet route, or `nil` if no sheet. Bind to `sheet(item:)`.
    var presentedSheet: Route?

    /// Presents the given route as a sheet (sets `presentedSheet`).
    ///
    /// - Parameter route: The route to present (e.g. `.addLocation`).
    func present(_ route: Route) {
        presentedSheet = route
    }

    /// Dismisses the current sheet (sets `presentedSheet` to `nil`).
    func dismissSheet() {
        presentedSheet = nil
    }

    /// Pushes the given route onto the navigation path.
    ///
    /// - Parameter route: The route to push.
    func push(_ route: Route) {
        path.append(route)
    }

    /// Pops the top route from the navigation path; no-op if path is empty.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Clears the entire navigation path (pops to root).
    func popToRoot() {
        path.removeAll()
    }
}

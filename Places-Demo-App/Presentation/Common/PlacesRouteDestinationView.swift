//
//  PlacesRouteDestinationView.swift
//  Places-Demo-App
//
//  Purpose: Switches on PlacesRoute to show the correct view for push destinations.
//  Dependencies: SwiftUI, PlacesRoute.
//  Usage: Used as navigationDestination in RootView's NavigationStack.
//

import SwiftUI

/// Maps each `PlacesRoute` to the view shown when that route is pushed on the navigation stack.
///
/// Used as the `navigationDestination(for: PlacesRoute.self)` content in `RootView`. Add one case per push destination; use `// MARK: - Feature` to group as the app grows. Currently `.addLocation` is presented as a sheet, so push destination for it is `EmptyView()`.
///
struct PlacesRouteDestinationView: View {

    /// The route that was pushed; determines which view to show.
    let route: PlacesRoute

    /// View for the pushed route (e.g. add location form for push, or EmptyView if only sheet is used).
    var body: some View {
        switch route {
        case .addLocation:
            EmptyView()
        }
    }
}

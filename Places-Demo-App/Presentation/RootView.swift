//
//  RootView.swift
//  Places-Demo-App
//
//  Purpose: Root container that owns the router and NavigationStack; builds content via dependencies.
//  Dependencies: SwiftUI, AppDependenciesProtocol, Router, PlacesRoute.
//  Usage: Shown in App body; production uses init() with DependencyContainer.live.
//

import SwiftUI

/// Root container that owns the app router and NavigationStack; builds content via dependencies.
///
/// Holds the single `Router<PlacesRoute>` and uses `AppDependenciesProtocol` to create the root list view and navigation destinations. In tests, pass a dependencies value built in the test target (e.g. `TestDependencies.make()`).
///
struct RootView: View {

    @State private var router = Router<PlacesRoute>()
    let dependencies: any AppDependenciesProtocol

    /// Creates the root view with the given dependencies (for dependency injection and tests).
    ///
    /// - Parameter dependencies: Factory for root view and view models (e.g. `DependencyContainer.live` or test double).
    init(dependencies: any AppDependenciesProtocol) {
        self.dependencies = dependencies
    }

    /// Production entry: uses live dependencies from `DependencyContainer.live`. Call from MainActor only (e.g. App body).
    @MainActor
    init() {
        self.init(dependencies: DependencyContainer.live)
    }

    /// NavigationStack with root list and navigation destination for `PlacesRoute`; content comes from dependencies.
    var body: some View {
        NavigationStack(path: $router.path) {
            dependencies.makeRootView(router: router)
                .navigationDestination(for: PlacesRoute.self) { route in
                    PlacesRouteDestinationView(route: route)
                }
        }
    }
}

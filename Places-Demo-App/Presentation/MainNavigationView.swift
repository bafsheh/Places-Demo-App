//
//  MainNavigationView.swift
//  Places-Demo-App
//
//  Purpose: Main navigation container that owns the router and NavigationStack; builds content via dependencies.
//  Dependencies: SwiftUI, AppDependenciesProtocol, Router, PlacesRoute.
//  Usage: Shown in App body; production uses init() with DependencyContainer.live.
//

import SwiftUI

/// Main navigation container that owns the app router and NavigationStack; builds content via dependencies.
///
/// Holds the single `Router<PlacesRoute>` and uses `AppDependenciesProtocol` to create the root list view. In tests, pass a dependencies value built in the test target (e.g. `TestDependencies.make()`).
///
struct MainNavigationView: View {

    @State private var router = Router<PlacesRoute>()
    let dependencies: any AppDependenciesProtocol

    /// Creates the main navigation view with the given dependencies (for dependency injection and tests).
    ///
    /// - Parameter dependencies: Factory for root view and view models (e.g. `DependencyContainer.live` or test double).
    init(dependencies: any AppDependenciesProtocol) {
        self.dependencies = dependencies
    }

    /// Production entry: uses live dependencies from `DependencyContainer.live`. Safe to call from any context; view creation happens on main when the body is evaluated.
    init() {
        self.init(dependencies: DependencyContainer.live)
    }

    /// NavigationStack with root list; content comes from dependencies.
    var body: some View {
        NavigationStack(path: $router.path) {
            dependencies.makeRootView(router: router)
        }
    }
}

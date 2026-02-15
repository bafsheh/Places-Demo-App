//
//  PlacesApp.swift
//  Places-Demo-App
//
//  Purpose: App entry point; configures the root window and scene.
//  Dependencies: SwiftUI.
//  Usage: @main entry; uses MainNavigationView as root content.
//

import SwiftUI

/// App entry point; configures the root window and scene.
///
/// Uses `MainNavigationView()` which in turn uses `DependencyContainer.live` for production dependencies. The root content is the locations list inside a NavigationStack. Marked with `@main` so the system launches this type as the app.
///
@main
struct PlacesApp: App {

    /// Single window with `MainNavigationView` as root content (NavigationStack and list).
    var body: some Scene {
        WindowGroup {
            MainNavigationView()
        }
    }
}

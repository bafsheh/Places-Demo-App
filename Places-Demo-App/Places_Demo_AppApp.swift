//
//  Places_Demo_AppApp.swift
//  Places-Demo-App
//
//  Purpose: App entry point; configures the root window and scene.
//  Dependencies: SwiftUI.
//  Usage: @main entry; uses RootView as root content.
//

import SwiftUI

/// App entry point; configures the root window and scene.
///
/// Uses `RootView()` which in turn uses `DependencyContainer.live` for production dependencies. The root content is the locations list inside a NavigationStack. Marked with `@main` so the system launches this type as the app.
///
/// - SeeAlso: `RootView`, `DependencyContainer`, `LocationListView`
@main
struct Places_Demo_AppApp: App {

    /// Single window with `RootView` as root content (NavigationStack and list).
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

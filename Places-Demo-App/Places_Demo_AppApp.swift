//
//  Places_Demo_AppApp.swift
//  Places-Demo-App
//

import SwiftUI

@main
struct Places_Demo_AppApp: App {
    var body: some Scene {
        WindowGroup {
            LocationListView(viewModel: DependencyContainer.makeLocationsListViewModel())
        }
    }
}

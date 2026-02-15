//
//  LocationListView.swift
//  Places-Demo-App
//
//  Purpose: Main list screen: loads locations, shows list/loading/error, add button and sheet, open-in-Wikipedia.
//  Dependencies: SwiftUI, Router, LocationListViewModel, AppDependenciesProtocol, ViewState, Location.
//  Usage: Created by Dependencies.makeRootView; displayed as root of NavigationStack.
//

import SwiftUI

/// Main list screen: loads locations, shows list/loading/error, add button and sheet, open-in-Wikipedia.
///
/// Drives UI from `viewModel.state` (idle/loading/loaded/error); presents add-location sheet via router; opens Wikipedia on row tap. Created by `Dependencies.makeRootView` and displayed as the root of the NavigationStack.
///
struct LocationListView: View {
    
    // MARK: - Properties
    
    @Bindable var router: Router<PlacesRoute>
    @State private var viewModel: LocationListViewModel
    @State private var addLocationContinuation: CheckedContinuation<Location?, Never>?
    let dependencies: any AppDependenciesProtocol
    
    // MARK: - Lifecycle
    
    /// Creates the list view with the given router, view model, and dependencies (for sheet factory).
    ///
    /// - Parameters:
    ///   - router: App router for presenting sheet and navigation.
    ///   - viewModel: View model that holds state and load/add/open actions.
    ///   - dependencies: Used to create `AddLocationViewModel` when add sheet is presented.
    init(router: Router<PlacesRoute>, viewModel: LocationListViewModel, dependencies: any AppDependenciesProtocol) {
        self.router = router
        self.viewModel = viewModel
        self.dependencies = dependencies
    }
    
    // MARK: - Body
    
    /// ZStack that switches on `viewModel.state`: loading, list of locations, or error with retry; toolbar add button and sheet binding.
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                LoadingView(message: LocalizationHelper.Places.loadingLocations)
            case .loaded(let locations):
                locationsList(locations)
            case .error(_, let message):
                ErrorView(message: message) {
                    Task {
                        await viewModel.loadLocations()
                    }
                }
            }
        }
        .navigationTitle(LocalizationHelper.Places.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        let result = await withCheckedContinuation { (cont: CheckedContinuation<Location?, Never>) in
                            addLocationContinuation = cont
                            router.present(.addLocation)
                        }
                        if let result {
                            viewModel.addLocation(result)
                        }
                        router.dismissSheet()
                    }
                } label: {
                    Label(LocalizationHelper.Places.add, systemImage: "plus.circle.fill")
                }
                .accessibilityHint(Accessibility.Places.addButtonHint)
                .accessibilityIdentifier(AccessibilityID.placesAddButton.rawValue)
            }
        }
        .sheet(item: $router.presentedSheet, onDismiss: {
            if let continuation = addLocationContinuation {
                continuation.resume(returning: nil)
                addLocationContinuation = nil
            }
            router.dismissSheet()
        }) { route in
            switch route {
            case .addLocation:
                AddLocationSheetHost(
                    continuation: $addLocationContinuation,
                    dependencies: dependencies
                )
            }
        }
        .task {
            await viewModel.loadLocations()
        }
    }
    
    // MARK: - Private
    
    /// List of location rows with tap-to-open-Wikipedia; accessibility and list style applied.
    ///
    /// - Parameter locations: Loaded locations to display.
    /// - Returns: A List view with `LocationRow` for each location.
    private func locationsList(_ locations: [Location]) -> some View {
        List {
            ForEach(locations) { location in
                LocationRow(location: location)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Task {
                            await viewModel.openLocation(location)
                        }
                    }
            }
        }
        .listStyle(.insetGrouped)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Accessibility.Places.listLabel)
        .accessibilityIdentifier(AccessibilityID.placesList.rawValue)
    }
}

// MARK: - Add Location Sheet Host

/// Host that creates `AddLocationViewModel` with the continuation when the sheet appears and clears the binding.
private struct AddLocationSheetHost: View {
    @Binding var continuation: CheckedContinuation<Location?, Never>?
    let dependencies: any AppDependenciesProtocol
    @State private var viewModel: AddLocationViewModel?
    
    var body: some View {
        Group {
            if let viewModel {
                AddLocationView(viewModel: viewModel)
            } else {
                ProgressView()
                    .onAppear {
                        if viewModel == nil, let cont = continuation {
                            viewModel = dependencies.makeAddLocationViewModel(continuation: cont)
                            continuation = nil
                        }
                    }
            }
        }
    }
}

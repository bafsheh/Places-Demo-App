import SwiftUI


struct LocationListView: View {

    @Bindable var router: Router<PlacesRoute>
    @State private var viewModel: LocationListViewModel
    let dependencies: any AppDependenciesProtocol

    init(router: Router<PlacesRoute>, viewModel: LocationListViewModel, dependencies: any AppDependenciesProtocol) {
        self.router = router
        self.viewModel = viewModel
        self.dependencies = dependencies
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                LoadingView(message: LocalizationHelper.Places.loadingLocations)
            case .loaded(let locations):
                locationsList(locations)
            case .error(let message):
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
                    router.present(.addLocation)
                } label: {
                    Label(LocalizationHelper.Places.add, systemImage: "plus.circle.fill")
                }
                .accessibilityHint(Accessibility.Places.addButtonHint)
                .accessibilityIdentifier(AccessibilityID.placesAddButton.rawValue)
            }
        }
        .sheet(item: $router.presentedSheet, onDismiss: { router.dismissSheet() }) { route in
            switch route {
            case .addLocation:
                AddLocationView(
                    viewModel: dependencies.makeAddLocationViewModel(onSubmit: { location in
                        viewModel.addLocation(location)
                        router.dismissSheet()
                    })
                )
            }
        }
        .task {
            await viewModel.loadLocations()
        }
    }

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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Accessibility.Places.listLabel)
        .accessibilityIdentifier(AccessibilityID.placesList.rawValue)
    }
}

import SwiftUI

/// Main view displaying list of locations
struct LocationListView: View {

    @State private var viewModel: LocationListViewModel

    init(viewModel: LocationListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle, .loading:
                    loadingView
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
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showCustomLocationSheet()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isCustomLocationSheetPresented) {
                addLocationSheet
            }
            .task {
                await viewModel.loadLocations()
            }
        }
    }

    private var addLocationSheet: some View {
        AddLocationView(
            viewModel: AddLocationViewModel { location in
                Task {
                    await viewModel.openLocation(location)
                }
                viewModel.hideCustomLocationSheet()
            }
        )
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading locations...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading locations")
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
    }
}

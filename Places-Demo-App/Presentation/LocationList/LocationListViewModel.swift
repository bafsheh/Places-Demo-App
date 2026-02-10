import Foundation
import Observation

@MainActor
@Observable
final class LocationListViewModel {

    private(set) var state: ViewState<[Location]> = .idle
    var isCustomLocationSheetPresented = false

    private let fetchLocationsUseCase: FetchLocationsUseCase

    init(fetchLocationsUseCase: FetchLocationsUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }

    func loadLocations() async {
        state = .loading

        do {
            let locations = try await fetchLocationsUseCase.execute()
            state = .loaded(locations)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func openLocation(_ location: Location) async {
    }

    func showCustomLocationSheet() {
        isCustomLocationSheetPresented = true
    }

    func hideCustomLocationSheet() {
        isCustomLocationSheetPresented = false
    }
}

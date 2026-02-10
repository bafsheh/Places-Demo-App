import Foundation
import Observation

@MainActor
@Observable
final class LocationListViewModel {

    private(set) var state: ViewState<[Location]> = .idle
    var isCustomLocationSheetPresented = false

    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let openWikipediaUseCase: OpenWikipediaUseCase

    init(
        fetchLocationsUseCase: FetchLocationsUseCase,
        openWikipediaUseCase: OpenWikipediaUseCase
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.openWikipediaUseCase = openWikipediaUseCase
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
        do {
            try await openWikipediaUseCase.execute(location: location)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func showCustomLocationSheet() {
        isCustomLocationSheetPresented = true
    }

    func hideCustomLocationSheet() {
        isCustomLocationSheetPresented = false
    }
}

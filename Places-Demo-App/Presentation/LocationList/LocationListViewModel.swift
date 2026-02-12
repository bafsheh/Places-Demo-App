import Foundation
import Observation

@MainActor
@Observable
final class LocationListViewModel {

    private(set) var state: ViewState<[Location]> = .idle

    private let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    private let openWikipediaUseCase: OpenWikipediaUseCaseProtocol
    
    private var LocationList: [Location] = []

    init(
        fetchLocationsUseCase: FetchLocationsUseCaseProtocol,
        openWikipediaUseCase: OpenWikipediaUseCaseProtocol
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.openWikipediaUseCase = openWikipediaUseCase
    }

    func loadLocations() async {
        state = .loading

        do {
            LocationList = try await fetchLocationsUseCase.execute()
            state = .loaded(LocationList)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func addLocation(_ location: Location) {
        LocationList.append(location)
        
        state = .loaded(LocationList)
    }

    func openLocation(_ location: Location) async {
        do {
            try await openWikipediaUseCase.execute(location: location)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

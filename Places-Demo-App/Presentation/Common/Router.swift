import Foundation
import Observation

/// App-specific route enum. Add cases (e.g. locationDetail) when adding push/sheet destinations.
enum PlacesRoute: Hashable, Identifiable {

    case addLocation

    var id: Self { self }
}

/// Generic router for NavigationStack path and presented sheet. Reusable for any Route: Hashable & Identifiable.
@MainActor
@Observable
final class Router<Route: Hashable & Identifiable> {

    var path: [Route] = []
    var presentedSheet: Route?

    func present(_ route: Route) {
        presentedSheet = route
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

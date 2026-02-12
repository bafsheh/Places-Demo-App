import SwiftUI

/// Maps each `PlacesRoute` to the view shown when that route is pushed on the navigation stack.
/// Add one case per push destination; use `// MARK: - Feature` to group as the app grows.
struct PlacesRouteDestinationView: View {

    let route: PlacesRoute

    var body: some View {
        switch route {
        case .addLocation:
            EmptyView()
        }
    }
}

#Preview {
    PlacesRouteDestinationView(route: .addLocation)
}

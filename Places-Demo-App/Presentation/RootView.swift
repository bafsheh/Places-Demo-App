import SwiftUI

/// Owns the single app router and NavigationStack; builds root content via dependencies.
/// In tests, pass a value built in the test target (e.g. `TestDependencies.make()`).
struct RootView: View {

    @State private var router = Router<PlacesRoute>()
    let dependencies: any AppDependenciesProtocol

    init(dependencies: any AppDependenciesProtocol) {
        self.dependencies = dependencies
    }

    /// Production entry: use live dependencies. Call from MainActor only (e.g. App body).
    @MainActor
    init() {
        self.init(dependencies: DependencyContainer.live)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            dependencies.makeRootView(router: router)
                .navigationDestination(for: PlacesRoute.self) { route in
                    PlacesRouteDestinationView(route: route)
                }
        }
    }
}

#Preview {
    RootView()
}

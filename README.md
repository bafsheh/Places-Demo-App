# Places Demo App

iOS app demonstrating Wikipedia deep linking with Clean Architecture.

## Requirements

- **iOS:** 17.0+ (current deployment target: 26.2 - update for production)
- **Xcode:** 15.0+
- **Swift:** 6.0
- **Concurrency:** Swift 6 strict concurrency enabled
- **Wikipedia app** (for deep link; optional)

> ⚠️ **Note:** Deployment target iOS 26.2 is set for development/testing.
> For production release, update to iOS 17.0 or 18.0 in project settings:
> **Project → Targets → Places-Demo-App → Deployment Info → iOS Deployment Target**

## Overview

- **Fetches locations** from a remote JSON API
- **Lists locations** in a SwiftUI list with names and coordinates
- **Deep links to Wikipedia** via `wikipedia://places?lat=&long=&name=`
- **Custom location** entry via sheet (lat/long)

## Architecture

### Clean Architecture + MVVM + Router

```
┌─────────────────────────────────────────┐
│           Presentation Layer             │
│  (Views, ViewModels, Router)             │
│  - SwiftUI Views                         │
│  - @MainActor ViewModels (@Observable)   │
│  - Router<PlacesRoute> for navigation    │
└─────────────────┬───────────────────────┘
                  │ depends on
                  ↓
┌─────────────────────────────────────────┐
│            Domain Layer                  │
│  (Entities, Use Cases, Protocols)        │
│  - Location entity                       │
│  - FetchLocationsUseCase                 │
│  - OpenWikipediaUseCase                  │
│  - Repository protocols                  │
└─────────────────┬───────────────────────┘
                  │ depends on
                  ↓
┌─────────────────────────────────────────┐
│             Data Layer                   │
│  (Repositories, Network, DTOs)           │
│  - LocationRepository                    │
│  - NetworkService (actor)                │
│  - RemoteDataSource                      │
│  - DeepLink services                     │
└─────────────────────────────────────────┘
```

#### Key Patterns

- **Repository Pattern:** Domain defines protocols, Data implements
- **Use Case Pattern:** Each feature has a dedicated use case
- **Router Pattern:** Type-safe navigation via `Router<PlacesRoute>`
- **Dependency Injection:** Protocol-based via `Dependencies` container; use `DependencyContainer.live` in the app; tests construct `Dependencies` with mock use cases
- **DTO Mapping:** DTOs in Data layer map to Domain entities

#### Swift 6 Concurrency

- ✅ Async/await throughout (no completion handlers)
- ✅ Actor for `NetworkService` (thread-safe I/O)
- ✅ `@MainActor` for UI (ViewModels, Views, Router)
- ✅ `Sendable` conformance on all shared types
- ✅ Strict concurrency checking enabled
- ✅ No data races (enforced at compile time)

To validate for data races, enable **Thread Sanitizer** in the Run scheme (Edit Scheme → Run → Diagnostics → Thread Sanitizer).

### Architecture & extension

- **Network and deep link** are generic: `NetworkService.request<T: Decodable & Sendable>(_ endpoint: EndpointProtocol)` and `DeepLinkService.open(_ url: URL)` are reused for any entity. New API entities use their own endpoint type (e.g. `FavoritesEndpoint`) and optionally their own data source; no need to edit existing ones.

- **Adding a new domain entity** (e.g. Favorites): add a domain model and repository protocol; add DTO and response type under `Data/Remote/`; add an endpoint type conforming to `EndpointProtocol` (see `LocationsEndpoint` in `Data/Remote/Endpoints/`); add a remote data source and repository implementation; add use case(s) and protocols; wire in `DependencyContainer`. The unit test target mirrors this structure (e.g. `Places-Demo-AppTests/Data/Remote/`, `Domain/UseCases/`) so mocks live alongside the code they double.

- **Adding a new screen**: add ViewModel (depending on use case protocols), add views, register a factory on `Dependencies` (e.g. `makeFavoritesListViewModel()`), and wire navigation from the app or existing screens.

## Building & Running

### Xcode

1. Open `Places-Demo-App.xcodeproj`
2. Select target: **Places-Demo-App**
3. Select simulator: **iPhone 15** (or any iOS 17+ simulator)
4. Press **Cmd+R** to build and run

### Command Line

```bash
# Build
xcodebuild -project Places-Demo-App.xcodeproj -scheme Places-Demo-App -configuration Debug

# Build and run tests
xcodebuild test -project Places-Demo-App.xcodeproj -scheme Places-Demo-App -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Environment

No environment variables or API keys required.
The app fetches location data from a public GitHub URL configured in `AppConfiguration.swift`.

## Testing

### Unit Testing

The app includes comprehensive unit tests for ViewModels, Use Cases, and Repository.

#### Running Tests

```bash
# Run all tests
xcodebuild test -scheme Places-Demo-App -destination 'platform=iOS Simulator,name=iPhone 15'

# Or use Xcode: Cmd+U
```

#### Test Structure

Tests use dependency injection with mock objects:

```swift
// Example: Testing LocationListViewModel
let mockFetchUseCase = MockFetchLocationsUseCase()
let mockOpenUseCase = MockOpenWikipediaUseCase()

let dependencies = Dependencies(
    fetchLocationsUseCase: mockFetchUseCase,
    openWikipediaUseCase: mockOpenUseCase
)

let viewModel = dependencies.makeLocationsListViewModel()

// Configure mock behavior
mockFetchUseCase.executeReturnValue = [sampleLocation1, sampleLocation2]

// Test
await viewModel.loadLocations()
XCTAssertEqual(viewModel.state, .loaded([sampleLocation1, sampleLocation2]))
```

#### Test Coverage

- ✅ **ViewModels:** LocationListViewModel, AddLocationViewModel
- ✅ **Use Cases:** FetchLocationsUseCase, OpenWikipediaUseCase
- ✅ **Repository:** LocationRepository with DTO mapping
- ✅ **Validation:** Coordinate validation, error handling

Target coverage: >70% for critical paths.

#### Mocks

All mocks are in `Places-Demo-AppTests/Mocks/` and conform to the same protocols as production implementations, making them easy to inject via `Dependencies`.

## Known Issues & Future Improvements

### Architecture

- ✅ Clean Architecture with MVVM + Router pattern
- ✅ Domain uses pure `Coordinate` type (no CoreLocation in Domain)
- ⚠️ Data layer uses `CoordinateMapper` for `CLLocationCoordinate2D` where needed (e.g. MapKit/CoreLocation APIs)
  - *Optional:* Further isolate or abstract if adding more map/location features

### Testing

- ✅ Comprehensive unit tests for critical paths
- ⚠️ UI tests not yet implemented
  - *Planned:* Critical flow tests (list, add, open Wikipedia)

### CI/CD

- ⚠️ No GitHub Actions workflow yet
  - *Planned:* Automated build, test, and lint on PR

## Deep Link

The app opens Wikipedia at a place using:

```
wikipedia://places?lat=52.35&long=4.83&name=Amsterdam
```

Ensure the Wikipedia app supports this URL format (see assignment Part 1).

## API

Locations are loaded from:

`https://raw.githubusercontent.com/abnamrocoesd/assignmentios/main/locations.json`

Expected response: `{ "locations": [ { "name": "...", "lat": 52.0, "long": 4.0 } ] }`

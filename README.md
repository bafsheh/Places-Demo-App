# Places Demo App

iOS app demonstrating Wikipedia deep linking with Clean Architecture.

## Overview

- **Fetches locations** from a remote JSON API
- **Lists locations** in a SwiftUI list with names and coordinates
- **Deep links to Wikipedia** via `wikipedia://places?lat=&long=&name=`
- **Custom location** entry via sheet (lat/long)

## Architecture

- **Domain**: `Location` entity, `LocationRepositoryProtocol`, use case protocols and implementations (`FetchLocationsUseCaseProtocol`, `OpenWikipediaUseCaseProtocol`)
- **Data**: Remote API layer under `Data/Remote/` (DTOs, Endpoints, NetworkService, DataSource, AppConfiguration); `Data/Repositories/` and `Data/DeepLink/` at Data level. `LocationRepository` implements `LocationRepositoryProtocol`; generic `NetworkService` and `DeepLinkService` for reuse.
- **Presentation**: `LocationListView`, `LocationListViewModel`, `LocationRow`, `AddLocationView`, `ErrorView`, generic `ViewState<Content>`
- **DI**: `DependencyContainer` and `Dependencies` (protocol-typed); use `DependencyContainer.live` in the app and `DependencyContainer.test(fetchLocations:openWikipedia:)` in tests

### Architecture & extension

- **Network and deep link** are generic: `NetworkService.request<T: Decodable & Sendable>(_ endpoint: EndpointProtocol)` and `DeepLinkService.open(_ url: URL)` are reused for any entity. New API entities use their own endpoint type (e.g. `FavoritesEndpoint`) and optionally their own data source; no need to edit existing ones.

- **Adding a new domain entity** (e.g. Favorites): add a domain model and repository protocol; add DTO and response type under `Data/Remote/`; add an endpoint type conforming to `EndpointProtocol` (see `LocationsEndpoint` in `Data/Remote/Endpoints/`); add a remote data source and repository implementation; add use case(s) and protocols; wire in `DependencyContainer`. The unit test target mirrors this structure (e.g. `Places-Demo-AppTests/Data/Remote/`, `Domain/UseCases/`) so mocks live alongside the code they double.

- **Adding a new screen**: add ViewModel (depending on use case protocols), add views, register a factory on `Dependencies` (e.g. `makeFavoritesListViewModel()`), and wire navigation from the app or existing screens.

## Requirements

- Xcode 15+
- iOS 17+
- Wikipedia app (for deep link; optional)

## Swift 6 & Concurrency

The app is built with **Swift 6** and **Strict Concurrency Checking** (complete). It uses async/await throughout the data and domain layers, an actor for `NetworkService`, and `@MainActor` for UI and view models. The add-location sheet uses a continuation-based flow (no `@escaping` callbacks). To validate for data races, enable **Thread Sanitizer** in the Run scheme (Edit Scheme → Run → Diagnostics → Thread Sanitizer).

## Build & Run

1. Open `Places-Demo-App.xcodeproj`
2. Select a simulator or device
3. Run (⌘R)

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

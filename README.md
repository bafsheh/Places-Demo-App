# Places Demo App

iOS app demonstrating Wikipedia deep linking with Clean Architecture.

## Overview

- **Fetches locations** from a remote JSON API
- **Lists locations** in a SwiftUI list with names and coordinates
- **Deep links to Wikipedia** via `wikipedia://places?lat=&long=&name=`
- **Custom location** entry via sheet (lat/long)

## Architecture

- **Domain**: `Location` entity, `LocationsRepositoryProtocol`, `FetchLocationsUseCase`, `OpenWikipediaUseCase`
- **Data**: `LocationDTO`, `RemoteDataSource`, `LocationsRepository`
- **Infrastructure**: `NetworkService`, `NetworkConfiguration`, `WikipediaDeepLinkService`
- **Presentation**: `LocationsListView`, `LocationsListViewModel`, `LocationRow`, `CustomLocationSheet`, `ErrorView`
- **DI**: `DependencyContainer` wires dependencies

## Requirements

- Xcode 15+
- iOS 17+
- Wikipedia app (for deep link; optional)

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

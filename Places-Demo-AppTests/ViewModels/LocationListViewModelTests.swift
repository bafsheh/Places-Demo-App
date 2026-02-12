//
//  LocationListViewModelTests.swift
//  Places-Demo-AppTests
//
//  Purpose: Unit tests for LocationListViewModel (load, add, open location; state transitions).
//  Dependencies: @testable Places_Demo_App, MockFetchLocationsUseCase, MockOpenWikipediaUseCase, ViewState, Location, NetworkError, OpenWikipediaError.
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite
struct LocationListViewModelTests {

    // MARK: - Fixtures

    private func makeSampleLocations(count: Int = 3) -> [Location] {
        (0..<count).map { i in
            Location(name: "Place \(i)", latitude: Double(52 + i), longitude: Double(4 + i))
        }
    }

    private func makeViewModel(
        fetchUseCase: MockFetchLocationsUseCase? = nil,
        openUseCase: MockOpenWikipediaUseCase? = nil
    ) -> LocationListViewModel {
        let fetch = fetchUseCase ?? MockFetchLocationsUseCase()
        let open = openUseCase ?? MockOpenWikipediaUseCase()
        return LocationListViewModel(
            fetchLocationsUseCase: fetch,
            openWikipediaUseCase: open
        )
    }

    // MARK: - loadLocations_success

    @Test
    func loadLocations_success() async {
        // Given: MockFetchLocationsUseCase returns 3 locations
        let locations = makeSampleLocations(count: 3)
        let mockFetch = MockFetchLocationsUseCase()
        mockFetch.locationsToReturn = locations
        let viewModel = makeViewModel(fetchUseCase: mockFetch)

        // When: viewModel.loadLocations() called
        await viewModel.loadLocations()

        // Then: state is .loaded([Location])
        guard case .loaded(let loaded) = viewModel.state else {
            #expect(Bool(false), "Expected state .loaded with 3 items, got \(viewModel.state)")
            return
        }
        #expect(loaded.count == 3)
        #expect(loaded.map { $0.name } == locations.map { $0.name })
        #expect(loaded.map { $0.coordinate.latitude } == locations.map { $0.coordinate.latitude })
        #expect(loaded.map { $0.coordinate.longitude } == locations.map { $0.coordinate.longitude })
    }

    // MARK: - loadLocations_failure

    @Test
    func loadLocations_failure() async {
        // Given: MockFetchLocationsUseCase throws NetworkError.noData
        let mockFetch = MockFetchLocationsUseCase()
        mockFetch.errorToThrow = NetworkError.noData
        let viewModel = makeViewModel(fetchUseCase: mockFetch)

        // When: viewModel.loadLocations() called
        await viewModel.loadLocations()

        // Then: state is .error(String)
        guard case .error(let message) = viewModel.state else {
            #expect(Bool(false), "Expected state .error, got \(viewModel.state)")
            return
        }
        #expect(
            message.contains("noData") || message.lowercased().contains("no data") || message.contains("No data"),
            "Error message should contain noData or localized description, got: \(message)"
        )
    }

    // MARK: - loadLocations_setsLoadingState

    @Test
    func loadLocations_setsLoadingState() async throws {
        // Given: Use case returns after delay
        let locations = makeSampleLocations(count: 2)
        let mockFetch = MockFetchLocationsUseCase()
        mockFetch.locationsToReturn = locations
        mockFetch.delayNanoseconds = 50_000_000 // 0.05s
        let viewModel = makeViewModel(fetchUseCase: mockFetch)

        // When: viewModel.loadLocations() called (start load in task so we can observe state)
        var states: [ViewState<[Location]>] = []
        let loadTask = Task {
            if case .idle = viewModel.state { states.append(.idle) }
            await viewModel.loadLocations()
        }
        // Brief yield to let loadLocations() set .loading
        try await Task.sleep(nanoseconds: 1_000_000)
        if case .loading = viewModel.state {
            states.append(.loading)
        }
        await loadTask.value
        if case .loaded(let content) = viewModel.state {
            states.append(.loaded(content))
        }

        // Then: state transitions idle → loading → loaded
        #expect(states.count == 3, "Expected idle, loading, loaded")
        if states.count >= 1 { #expect(states[0] == .idle) }
        if states.count >= 2 { #expect(states[1] == .loading) }
        if states.count >= 3, case .loaded(let loaded) = states[2] {
            #expect(loaded.count == 2)
        }
    }

    // MARK: - addLocation_success

    @Test
    func addLocation_success() async {
        // Given: ViewModel with loaded locations
        let initial = makeSampleLocations(count: 2)
        let mockFetch = MockFetchLocationsUseCase()
        mockFetch.locationsToReturn = initial
        let viewModel = makeViewModel(fetchUseCase: mockFetch)
        await viewModel.loadLocations()
        guard case .loaded(let before) = viewModel.state else {
            #expect(Bool(false), "Expected loaded state after loadLocations")
            return
        }
        #expect(before.count == 2)

        let newLocation = Location(name: "New", latitude: 52.5, longitude: 4.5)

        // When: viewModel.addLocation(newLocation) called
        viewModel.addLocation(newLocation)

        // Then: location added to array; state remains .loaded with updated array
        guard case .loaded(let after) = viewModel.state else {
            #expect(Bool(false), "Expected state .loaded after addLocation, got \(viewModel.state)")
            return
        }
        #expect(after.count == 3)
        let hasNew = after.contains { loc in
            loc.name == "New" && abs(loc.coordinate.latitude - 52.5) < 0.001
        }
        #expect(hasNew)
    }

    // MARK: - openLocation_success

    @Test
    func openLocation_success() async throws {
        // Given: MockOpenWikipediaUseCase succeeds
        let location = Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89)
        let mockOpen = MockOpenWikipediaUseCase()
        let viewModel = makeViewModel(openUseCase: mockOpen)

        // When: viewModel.openLocation(location) called
        await viewModel.openLocation(location)

        // Then: No error state; use case execute() was called
        if case .error(let msg) = viewModel.state {
            #expect(Bool(false), "Expected no error state after openLocation success: \(msg)")
        }
        #expect(mockOpen.openedLocations.count == 1)
        let opened = try #require(mockOpen.openedLocations.first)
        #expect(opened.name == "Amsterdam")
        #expect(abs(opened.coordinate.latitude - 52.37) < 0.001)
    }

    // MARK: - openLocation_failure

    @Test
    func openLocation_failure() async {
        // Given: MockOpenWikipediaUseCase throws DeepLinkError.appNotInstalled
        let location = Location(name: "Paris", latitude: 48.85, longitude: 2.35)
        let mockOpen = MockOpenWikipediaUseCase()
        mockOpen.errorToThrow = OpenWikipediaError.appNotInstalled(appName: "Wikipedia")
        let viewModel = makeViewModel(openUseCase: mockOpen)

        // When: viewModel.openLocation(location) called
        await viewModel.openLocation(location)

        // Then: state is .error(String); error message appropriate
        guard case .error(let message) = viewModel.state else {
            #expect(Bool(false), "Expected state .error after openLocation failure, got \(viewModel.state)")
            return
        }
        #expect(
            message.lowercased().contains("wikipedia") || message.lowercased().contains("installed"),
            "Error message should reference app not installed, got: \(message)"
        )
    }
}

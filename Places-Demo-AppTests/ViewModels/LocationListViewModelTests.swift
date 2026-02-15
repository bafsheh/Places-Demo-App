//
//  LocationListViewModelTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("LocationListViewModel load, add, open location and state transitions")
struct LocationListViewModelTests {

    private func makeSampleLocations(count: Int = 3) -> [Location] {
        (0..<count).map { i in
            Location(name: "Place \(i)", latitude: Double(52 + i), longitude: Double(4 + i))
        }
    }

    @Test("loadLocations sets state to loaded with locations when fetch succeeds")
    func loadLocations_success() async {
        let locations = makeSampleLocations(count: 3)
        let (deps, _, _) = TestDependencies.makeForLocationList(locations: locations)
        let viewModel = deps.makeLocationsListViewModel()

        await viewModel.loadLocations()

        guard case .loaded(let loaded) = viewModel.state else {
            #expect(Bool(false), "Expected state .loaded with 3 items, got \(viewModel.state)")
            return
        }
        #expect(loaded.count == 3)
        #expect(loaded.map { $0.name } == locations.map { $0.name })
        #expect(loaded.map { $0.coordinate.latitude } == locations.map { $0.coordinate.latitude })
        #expect(loaded.map { $0.coordinate.longitude } == locations.map { $0.coordinate.longitude })
    }

    @Test("loadLocations sets state to error when fetch throws")
    func loadLocations_failure() async {
        let deps = TestDependencies.makeWithErrors(fetchError: NetworkError.noData)
        let viewModel = deps.makeLocationsListViewModel()

        await viewModel.loadLocations()

        guard case .error(let error, let message) = viewModel.state else {
            #expect(Bool(false), "Expected state .error, got \(viewModel.state)")
            return
        }
        #expect(error is NetworkError, "Expected underlying error to be NetworkError")
        #expect(!message.isEmpty, "Error message should not be empty")
    }

    @Test("loadLocations transitions state from idle through loading to loaded")
    func loadLocations_setsLoadingState() async throws {
        let locations = makeSampleLocations(count: 2)
        let (deps, fetchMock, _) = TestDependencies.makeForLocationList(locations: locations)
        fetchMock.delayNanoseconds = 50_000_000
        let viewModel = deps.makeLocationsListViewModel()

        var states: [ViewState<[Location]>] = []
        let loadTask = Task {
            if case .idle = viewModel.state { states.append(.idle) }
            await viewModel.loadLocations()
        }
        try await Task.sleep(nanoseconds: 1_000_000)
        if case .loading = viewModel.state {
            states.append(.loading)
        }
        await loadTask.value
        if case .loaded(let content) = viewModel.state {
            states.append(.loaded(content))
        }

        #expect(states.count == 3, "Expected idle, loading, loaded")
        if states.count >= 1 { #expect(states[0] == .idle) }
        if states.count >= 2 { #expect(states[1] == .loading) }
        if states.count >= 3, case .loaded(let loaded) = states[2] {
            #expect(loaded.count == 2)
        }
    }

    @Test("addLocation appends location and updates state to loaded with new list")
    func addLocation_success() async {
        let initial = makeSampleLocations(count: 2)
        let (deps, _, _) = TestDependencies.makeForLocationList(locations: initial)
        let viewModel = deps.makeLocationsListViewModel()
        await viewModel.loadLocations()
        guard case .loaded(let before) = viewModel.state else {
            #expect(Bool(false), "Expected loaded state after loadLocations")
            return
        }
        #expect(before.count == 2)

        let newLocation = Location(name: "New", latitude: 52.5, longitude: 4.5)

        viewModel.addLocation(newLocation)

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

    @Test("openLocation does not set error and calls use case when open succeeds")
    func openLocation_success() async throws {
        let location = Location(name: "Amsterdam", latitude: 52.37, longitude: 4.89)
        let (deps, _, openMock) = TestDependencies.makeForLocationList()
        let viewModel = deps.makeLocationsListViewModel()

        await viewModel.openLocation(location)

        if case .error(_, let msg) = viewModel.state {
            #expect(Bool(false), "Expected no error state after openLocation success: \(msg)")
        }
        #expect(openMock.openedLocations.count == 1)
        let opened = try #require(openMock.openedLocations.first)
        #expect(opened.name == "Amsterdam")
        #expect(abs(opened.coordinate.latitude - 52.37) < 0.001)
    }

    @Test("openLocation sets openLocationError and leaves state unchanged when open use case throws")
    func openLocation_failure() async {
        let location = Location(name: "Paris", latitude: 48.85, longitude: 2.35)
        let deps = TestDependencies.makeWithErrors(openError: OpenWikipediaError.appNotInstalled(appName: "Wikipedia"))
        let viewModel = deps.makeLocationsListViewModel()
        await viewModel.loadLocations()
        guard case .loaded(let beforeLoad) = viewModel.state else {
            #expect(Bool(false), "Expected loaded state before openLocation")
            return
        }

        await viewModel.openLocation(location)

        #expect(viewModel.openLocationError != nil, "Expected openLocationError to be set")
        if case .appNotInstalled(let name) = viewModel.openLocationError {
            #expect(name == "Wikipedia")
        } else {
            #expect(Bool(false), "Expected openLocationError .appNotInstalled(appName: \"Wikipedia\"), got \(String(describing: viewModel.openLocationError))")
        }
        guard case .loaded(let loaded) = viewModel.state else {
            #expect(Bool(false), "Expected state to remain .loaded after openLocation failure, got \(viewModel.state)")
            return
        }
        #expect(loaded.count == beforeLoad.count, "State should be unchanged")
    }

    @Test("dismissOpenLocationError clears openLocationError")
    func dismissOpenLocationError_clearsError() async {
        let deps = TestDependencies.makeWithErrors(openError: OpenWikipediaError.cannotOpenURL)
        let viewModel = deps.makeLocationsListViewModel()
        await viewModel.loadLocations()
        let location = Location(name: "X", latitude: 0, longitude: 0)
        await viewModel.openLocation(location)
        #expect(viewModel.openLocationError != nil)

        viewModel.dismissOpenLocationError()

        #expect(viewModel.openLocationError == nil)
    }

    @Test("second loadLocations cancels first and final state is from second load")
    func loadLocations_secondCallCancelsFirst() async {
        let firstBatch = makeSampleLocations(count: 1)
        let secondBatch = makeSampleLocations(count: 2)
        let (deps, fetchMock, _) = TestDependencies.makeForLocationList(locations: firstBatch)
        fetchMock.delayNanoseconds = 200_000_000 // 200ms so first load is in flight
        let viewModel = deps.makeLocationsListViewModel()

        async let firstLoad: () = viewModel.loadLocations()
        fetchMock.locationsToReturn = secondBatch
        fetchMock.delayNanoseconds = 0
        await viewModel.loadLocations()
        await firstLoad

        guard case .loaded(let loaded) = viewModel.state else {
            #expect(Bool(false), "Expected state .loaded after second load, got \(viewModel.state)")
            return
        }
        #expect(loaded.count == 2, "Final state should be from second load (2 items), got \(loaded.count)")
    }
}

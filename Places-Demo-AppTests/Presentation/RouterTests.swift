//
//  RouterTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("Router present, dismissSheet, push, pop and popToRoot")
struct RouterTests {

    @Test("present sets presentedSheet to route")
    func present() {
        let router = Router<PlacesRoute>()
        #expect(router.presentedSheet == nil)
        router.present(.addLocation)
        #expect(router.presentedSheet == .addLocation)
    }

    @Test("dismissSheet clears presentedSheet")
    func dismissSheet() {
        let router = Router<PlacesRoute>()
        router.present(.addLocation)
        router.dismissSheet()
        #expect(router.presentedSheet == nil)
    }

    @Test("push appends route to path")
    func push() {
        let router = Router<PlacesRoute>()
        #expect(router.path.isEmpty)
        router.push(.addLocation)
        #expect(router.path.count == 1)
        #expect(router.path.first == .addLocation)
    }

    @Test("pop removes last from path when not empty")
    func pop() {
        let router = Router<PlacesRoute>()
        router.push(.addLocation)
        router.pop()
        #expect(router.path.isEmpty)
    }

    @Test("pop is no-op when path is empty")
    func pop_empty() {
        let router = Router<PlacesRoute>()
        router.pop()
        #expect(router.path.isEmpty)
    }

    @Test("popToRoot clears path")
    func popToRoot() {
        let router = Router<PlacesRoute>()
        router.push(.addLocation)
        router.push(.addLocation)
        router.popToRoot()
        #expect(router.path.isEmpty)
    }
}

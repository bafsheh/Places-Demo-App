//
//  ViewStateTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("ViewState isLoading, content, errorMessage, underlyingError and Equatable")
struct ViewStateTests {

    @Test("isLoading is true only for loading case")
    func isLoading() {
        #expect(ViewState<[Location]>.idle.isLoading == false)
        #expect(ViewState<[Location]>.loading.isLoading == true)
        let loc = Location(name: "A", latitude: 0, longitude: 0)
        #expect(ViewState.loaded([loc]).isLoading == false)
        #expect(ViewState<[Location]>.error(error: NetworkError.noData, message: "err").isLoading == false)
    }

    @Test("content returns value only for loaded case")
    func content() {
        let loc = Location(name: "X", latitude: 1, longitude: 2)
        #expect(ViewState<[Location]>.idle.content == nil)
        #expect(ViewState.loaded([loc]).content?.count == 1)
        #expect(ViewState<[Location]>.error(error: NetworkError.noData, message: "m").content == nil)
    }

    @Test("errorMessage returns message only for error case")
    func errorMessage() {
        #expect(ViewState<[Location]>.idle.errorMessage == nil)
        #expect(ViewState<[Location]>.error(error: NetworkError.noData, message: "No data").errorMessage == "No data")
    }

    @Test("underlyingError returns error only for error case")
    func underlyingError() {
        #expect(ViewState<[Location]>.idle.underlyingError == nil)
        let err = NetworkError.noData
        let state = ViewState<[Location]>.error(error: err, message: "msg")
        if case .noData = state.underlyingError as? NetworkError {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected underlyingError to be NetworkError.noData")
        }
    }

    @Test("Equatable same cases are equal")
    func equatable_same() {
        let loc = Location(name: "A", latitude: 0, longitude: 0)
        #expect(ViewState<[Location]>.idle == .idle)
        #expect(ViewState<[Location]>.loading == .loading)
        #expect(ViewState.loaded([loc]) == ViewState.loaded([loc]))
        #expect(ViewState<[Location]>.error(error: NetworkError.noData, message: "m") == ViewState<[Location]>.error(error: NetworkError.noData, message: "m"))
    }

    @Test("Equatable different cases are not equal")
    func equatable_different() {
        let loc = Location(name: "A", latitude: 0, longitude: 0)
        #expect(ViewState<[Location]>.idle != .loading)
        #expect(ViewState.loaded([loc]) != .idle)
    }
}

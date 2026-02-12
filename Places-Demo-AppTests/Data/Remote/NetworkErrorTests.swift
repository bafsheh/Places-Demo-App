//
//  NetworkErrorTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@Suite("NetworkError errorDescription for all cases")
struct NetworkErrorTests {

    @Test("invalidURL has correct errorDescription")
    func invalidURL() {
        #expect(NetworkError.invalidURL.errorDescription == "Invalid URL")
    }

    @Test("noData has correct errorDescription")
    func noData() {
        #expect(NetworkError.noData.errorDescription == "No data received")
    }

    @Test("decodingError with message returns that message")
    func decodingError_withMessage() {
        #expect(NetworkError.decodingError("Bad JSON").errorDescription == "Bad JSON")
    }

    @Test("decodingError with empty message returns Decoding error")
    func decodingError_emptyMessage() {
        #expect(NetworkError.decodingError("").errorDescription == "Decoding error")
    }

    @Test("httpError has correct errorDescription with status code")
    func httpError() {
        #expect(NetworkError.httpError(statusCode: 404).errorDescription == "HTTP error: 404")
    }

    @Test("networkFailure with message returns that message")
    func networkFailure_withMessage() {
        #expect(NetworkError.networkFailure("Connection lost").errorDescription == "Connection lost")
    }

    @Test("networkFailure with empty message returns Network failure")
    func networkFailure_emptyMessage() {
        #expect(NetworkError.networkFailure("").errorDescription == "Network failure")
    }

    @Test("unknown has correct errorDescription")
    func unknown() {
        #expect(NetworkError.unknown.errorDescription == "Unknown error")
    }
}

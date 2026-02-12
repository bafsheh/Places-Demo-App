//
//  DomainErrorTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("OpenWikipediaError errorDescription for all cases")
struct DomainErrorTests {

    @Test("urlCreationFailed has correct errorDescription")
    func urlCreationFailed() {
        #expect(OpenWikipediaError.urlCreationFailed.errorDescription == "Failed to create URL")
    }

    @Test("cannotOpenURL has correct errorDescription")
    func cannotOpenURL() {
        #expect(OpenWikipediaError.cannotOpenURL.errorDescription == "Cannot open URL")
    }

    @Test("appNotInstalled with nil has correct errorDescription")
    func appNotInstalled_nil() {
        #expect(OpenWikipediaError.appNotInstalled(appName: nil).errorDescription == "App is not installed")
    }

    @Test("appNotInstalled with app name has correct errorDescription")
    func appNotInstalled_withName() {
        #expect(OpenWikipediaError.appNotInstalled(appName: "Wikipedia").errorDescription == "Wikipedia is not installed")
    }
}

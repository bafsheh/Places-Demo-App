//
//  AppConfigurationTests.swift
//  Places-Demo-AppTests
//

import Testing
@testable import Places_Demo_App

@MainActor
@Suite("AppConfiguration apiBaseURL")
struct AppConfigurationTests {

    @Test("apiBaseURL returns default base URL when no plist or env override")
    func apiBaseURL_returnsDefault() {
        let url = AppConfiguration.apiBaseURL
        #expect(!url.isEmpty)
        #expect(url.hasPrefix("https://"))
    }
}

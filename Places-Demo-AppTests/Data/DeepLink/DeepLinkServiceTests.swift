//
//  DeepLinkServiceTests.swift
//  Places-Demo-AppTests
//

import Foundation
import Testing
@testable import Places_Demo_App

@Suite("DeepLinkService and DeepLinkError")
struct DeepLinkServiceTests {

    @Test("DeepLinkError urlCreationFailed has correct errorDescription")
    func deepLinkError_urlCreationFailed() {
        let error = DeepLinkError.urlCreationFailed
        #expect(error.errorDescription == "Failed to create URL")
    }

    @Test("DeepLinkError cannotOpenURL has correct errorDescription")
    func deepLinkError_cannotOpenURL() {
        let error = DeepLinkError.cannotOpenURL
        #expect(error.errorDescription == "Cannot open URL")
    }

    @Test("DeepLinkError appNotInstalled with nil has correct errorDescription")
    func deepLinkError_appNotInstalled_nil() {
        let error = DeepLinkError.appNotInstalled(appName: nil)
        #expect(error.errorDescription == "App is not installed")
    }

    @Test("DeepLinkError appNotInstalled with app name has correct errorDescription")
    func deepLinkError_appNotInstalled_withName() {
        let error = DeepLinkError.appNotInstalled(appName: "Wikipedia")
        #expect(error.errorDescription == "Wikipedia is not installed")
    }

    @Test("open(url) succeeds when opener returns true")
    func open_succeeds() async throws {
        let opener = MockURLOpener()
        opener.shouldSucceed = true
        let service = DeepLinkService(urlOpener: opener)
        let url = URL(string: "https://example.com")!

        try await service.open(url)

        #expect(opener.lastOpenedURL == url)
    }

    @Test("open(url) throws appNotInstalled when opener returns false")
    func open_throwsWhenOpenerFails() async {
        let opener = MockURLOpener()
        opener.shouldSucceed = false
        let service = DeepLinkService(urlOpener: opener)
        let url = URL(string: "https://example.com")!

        do {
            try await service.open(url)
            #expect(Bool(false), "Expected throw")
        } catch let error as DeepLinkError {
            if case .appNotInstalled(let name) = error {
                #expect(name == nil)
            } else {
                #expect(Bool(false), "Expected appNotInstalled, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Expected DeepLinkError, got \(error)")
        }
    }
}

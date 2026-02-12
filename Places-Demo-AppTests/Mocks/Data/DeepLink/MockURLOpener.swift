//
//  MockURLOpener.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for URLOpening; returns configurable success/failure without opening real URLs.
//  Usage: Use in unit tests (e.g. DeepLinkService) to avoid UIApplication.open.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `URLOpening`. Set `shouldSucceed` and inspect `lastOpenedURL` to verify behavior.
final class MockURLOpener: URLOpening, @unchecked Sendable {

    var shouldSucceed = true
    var lastOpenedURL: URL?

    func open(_ url: URL) async -> Bool {
        lastOpenedURL = url
        return shouldSucceed
    }
}

//
//  MockURLOpener.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock URLOpener for tests. Returns configurable result without opening real URLs.
final class MockURLOpener: URLOpening, @unchecked Sendable {

    var shouldSucceed = true
    var lastOpenedURL: URL?

    func open(_ url: URL) async -> Bool {
        lastOpenedURL = url
        return shouldSucceed
    }
}

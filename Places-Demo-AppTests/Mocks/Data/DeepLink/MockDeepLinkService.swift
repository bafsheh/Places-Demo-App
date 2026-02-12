//
//  MockDeepLinkService.swift
//  Places-Demo-AppTests
//
//  Purpose: Test double for DeepLinkServiceProtocol; records opened URLs and can throw or succeed.
//  Usage: Use in unit tests (e.g. WikipediaDeepLinkService) to avoid opening real URLs.
//

import Foundation
@testable import Places_Demo_App

/// Mock for unit testing; conforms to `DeepLinkServiceProtocol`. Set `openedURLs` to inspect calls; `errorToThrow` to simulate failure.
final class MockDeepLinkService: DeepLinkServiceProtocol, @unchecked Sendable {

    var openedURLs: [URL] = []
    var errorToThrow: Error?

    func open(_ url: URL) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
        openedURLs.append(url)
    }
}

//
//  MockDeepLinkService.swift
//  Places-Demo-AppTests
//

import Foundation
@testable import Places_Demo_App

/// Mock DeepLinkService for tests. Records opened URLs and can throw or succeed.
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

//
//  DeepLinkService.swift
//  Places-Demo-App
//
//  Purpose: Generic deep link handling (open URL via injectable opener); errors and URL opener protocol.
//  Dependencies: UIKit (UIApplication for DefaultURLOpener).
//  Usage: DeepLinkService used by WikipediaDeepLinkService; URLOpening injected for tests.
//

import Foundation
import UIKit

/// Errors that can occur when opening a deep link.
enum DeepLinkError: LocalizedError, Sendable {

    /// URL could not be constructed (e.g. invalid components).
    case urlCreationFailed

    /// System could not open the URL (generic failure).
    case cannotOpenURL

    /// Target app (e.g. Wikipedia) is not installed; associated value is the app name if known.
    case appNotInstalled(appName: String?)

    var errorDescription: String? {
        switch self {
        case .urlCreationFailed:
            return "Failed to create URL"
        case .cannotOpenURL:
            return "Cannot open URL"
        case .appNotInstalled(let name):
            return name.map { "\($0) is not installed" } ?? "App is not installed"
        }
    }
}

/// Protocol for opening URLs in the system (e.g. another app or browser); allows injection of a mock in tests.
protocol URLOpening: Sendable {

    /// Attempts to open the given URL (e.g. via `UIApplication.shared.open`).
    ///
    /// - Parameter url: The URL to open.
    /// - Returns: `true` if the URL was opened, `false` otherwise (e.g. app not installed).
    func open(_ url: URL) async -> Bool
}

/// Default implementation that uses `UIApplication.shared` to open URLs.
///
/// - Important: Must be used from the main actor; conforms to `URLOpening` for production. Tests inject a mock.
@MainActor
final class DefaultURLOpener: URLOpening {

    /// Opens the URL via `UIApplication.shared.open(url)`.
    ///
    /// - Parameter url: The URL to open.
    /// - Returns: Result of the system open call.
    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}

/// Contract for a generic deep link service that can open any URL.
///
/// Used by Wikipedia-specific code to open `wikipedia://places?...`; other deep link types could use the same protocol.
protocol DeepLinkServiceProtocol: Sendable {

    /// Opens the given URL (e.g. Wikipedia Places, maps).
    ///
    /// - Parameter url: The URL to open.
    /// - Throws: `DeepLinkError.appNotInstalled` when the URL could not be opened (e.g. app not installed).
    func open(_ url: URL) async throws
}

/// Generic deep link service that opens URLs via an injectable opener.
///
/// Converts opener result to throws: if opener returns `false`, throws `DeepLinkError.appNotInstalled`. Used by `WikipediaDeepLinkService`.
@MainActor
final class DeepLinkService: DeepLinkServiceProtocol {

    private let urlOpener: URLOpening

    /// Creates the service with the given URL opener (e.g. `DefaultURLOpener` or a test mock).
    ///
    /// - Parameter urlOpener: Implementation that performs the system open.
    init(urlOpener: URLOpening) {
        self.urlOpener = urlOpener
    }

    /// Opens the URL via the injectable opener; throws if opening failed.
    ///
    /// - Parameter url: The URL to open.
    /// - Throws: `DeepLinkError.appNotInstalled(appName: nil)` when the opener returns `false`.
    func open(_ url: URL) async throws {
        let opened = await urlOpener.open(url)
        guard opened else {
            throw DeepLinkError.appNotInstalled(appName: nil)
        }
    }
}

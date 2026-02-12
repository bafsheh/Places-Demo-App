import Foundation
import UIKit

/// Errors that can occur when opening a deep link.
enum DeepLinkError: LocalizedError, Sendable {
    case urlCreationFailed
    case cannotOpenURL
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

/// Protocol for opening URLs. Allows injection of a mock in tests.
protocol URLOpening: Sendable {

    /// Attempts to open the given URL.
    /// - Returns: `true` if the URL was opened, `false` otherwise.
    func open(_ url: URL) async -> Bool
}

/// Default implementation that uses `UIApplication.shared` to open URLs.
@MainActor
final class DefaultURLOpener: URLOpening {

    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}

/// Protocol for a generic deep link service that can open any URL.
protocol DeepLinkServiceProtocol: Sendable {

    /// Opens the given URL. Can be used for any deep link (Wikipedia, maps, etc.).
    /// - Parameter url: The URL to open.
    /// - Throws: `DeepLinkError.appNotInstalled` if the URL could not be opened.
    func open(_ url: URL) async throws
}

/// Generic deep link service that opens URLs via an injectable opener.
@MainActor
final class DeepLinkService: DeepLinkServiceProtocol {

    private let urlOpener: URLOpening

    init(urlOpener: URLOpening) {
        self.urlOpener = urlOpener
    }

    func open(_ url: URL) async throws {
        let opened = await urlOpener.open(url)
        guard opened else {
            throw DeepLinkError.appNotInstalled(appName: nil)
        }
    }
}

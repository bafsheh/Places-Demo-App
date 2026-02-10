import Foundation
import UIKit
import CoreLocation

/// Errors related to deep linking
enum DeepLinkError: LocalizedError, Sendable {
    case urlCreationFailed
    case cannotOpenURL
    case wikipediaNotInstalled

    var errorDescription: String? {
        switch self {
        case .urlCreationFailed:
            return "Failed to create URL"
        case .cannotOpenURL:
            return "Cannot open URL"
        case .wikipediaNotInstalled:
            return "Wikipedia app is not installed"
        }
    }
}

/// Protocol for Wikipedia deep linking service
protocol WikipediaDeepLinkServiceProtocol: Sendable {

    /// Opens Wikipedia Places tab at specified location
    func openPlaces(at location: Location) async throws
}

/// Service for creating and opening Wikipedia deep links
@MainActor
final class WikipediaDeepLinkService: WikipediaDeepLinkServiceProtocol {

    private enum Constants {
        static let scheme = "wikipedia"
        static let host = "places"
    }

    func openPlaces(at location: Location) async throws {
        guard let url = buildDeepLinkURL(for: location) else {
            throw DeepLinkError.urlCreationFailed
        }

        // Try to open directly. canOpenURL can return false if LSApplicationQueriesSchemes
        // doesn't include "wikipedia" in Info.plist (must be an array), so we don't rely on it.
        let opened = await UIApplication.shared.open(url)

        guard opened else {
            throw DeepLinkError.wikipediaNotInstalled
        }
    }

    private func buildDeepLinkURL(for location: Location) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host

        var queryItems = [
            URLQueryItem(
                name: "lat",
                value: String(location.coordinate.latitude)
            ),
            URLQueryItem(
                name: "long",
                value: String(location.coordinate.longitude)
            )
        ]

        if let name = location.name {
            queryItems.append(
                URLQueryItem(name: "name", value: name)
            )
        }

        components.queryItems = queryItems

        return components.url
    }
}

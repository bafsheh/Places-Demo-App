//
//  WikipediaDeepLinkService.swift
//  Places-Demo-App
//
//  Purpose: Builds Wikipedia Places URLs and opens them via the generic deep link service.
//  Dependencies: Location, DeepLinkServiceProtocol.
//  Usage: WikipediaDeepLinkService injected into OpenWikipediaUseCase.
//

import Foundation

/// Builds Wikipedia Places deep link URLs (`wikipedia://places?lat=...&long=...&name=...`).
enum WikipediaPlacesURLBuilder: Sendable {

    private enum Constants {
        static let scheme = "wikipedia"
        static let host = "places"
    }

    /// Builds a `wikipedia://places` URL with lat, long, and optional name query parameters.
    ///
    /// - Parameter location: The location (coordinates and optional name).
    /// - Returns: URL if construction succeeds, `nil` otherwise.
    static func build(for location: Location) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host

        var queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "long", value: String(location.coordinate.longitude))
        ]
        if let name = location.name {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        components.queryItems = queryItems

        return components.url
    }
}

/// Contract for opening Wikipedia Places at a location; allows injection of mocks in tests.
protocol WikipediaDeepLinkServiceProtocol: Sendable {

    /// Opens the Wikipedia app (or fallback) at the specified location (e.g. Places tab with coordinates).
    ///
    /// - Parameter location: The location to show (coordinates and optional name).
    /// - Throws: `DeepLinkError` when the URL cannot be built or opened.
    func openPlaces(at location: Location) async throws
}

/// Wikipedia-specific deep link handler; builds Places URL and opens it via the generic deep link service.
///
/// Uses `WikipediaPlacesURLBuilder` for URL construction and `DeepLinkServiceProtocol` for opening; maps failures to `DeepLinkError.appNotInstalled(appName: "Wikipedia")` when appropriate.
final class WikipediaDeepLinkService: WikipediaDeepLinkServiceProtocol {

    private let deepLinkService: DeepLinkServiceProtocol

    /// Creates the service with the given generic deep link service.
    ///
    /// - Parameter deepLinkService: Service that opens URLs (e.g. `DeepLinkService` or a test mock).
    init(deepLinkService: DeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }

    /// Opens Wikipedia at the specified location.
    ///
    /// - Parameter location: The location (coordinates and optional name) to show in Wikipedia Places.
    /// - Throws: `DeepLinkError.urlCreationFailed` if URL build fails; `DeepLinkError.appNotInstalled(appName: "Wikipedia")` if open fails.
    func openPlaces(at location: Location) async throws {
        guard let url = WikipediaPlacesURLBuilder.build(for: location) else {
            throw DeepLinkError.urlCreationFailed
        }
        do {
            try await deepLinkService.open(url)
        } catch {
            throw DeepLinkError.appNotInstalled(appName: "Wikipedia")
        }
    }
}

// MARK: - Adapter (Data → Domain Port)

/// Adapter that implements the Domain port `OpenWikipediaAtLocationPort` by delegating to `WikipediaDeepLinkService`.
///
/// **Adapter pattern (Clean Architecture):** Domain defines the port (`OpenWikipediaAtLocationPort`); Data implements it
/// with this adapter, which wraps the existing `WikipediaDeepLinkService` and maps Data-layer `DeepLinkError` to
/// Domain-layer `OpenWikipediaError`. This keeps Domain independent of Data while preserving existing deep link behavior.
final class WikipediaDeepLinkAdapter: OpenWikipediaAtLocationPort {

    private let deepLinkService: WikipediaDeepLinkServiceProtocol

    /// Creates the adapter with the given Wikipedia deep link service.
    ///
    /// - Parameter deepLinkService: Service that builds and opens Wikipedia Places URLs (e.g. `WikipediaDeepLinkService`).
    init(deepLinkService: WikipediaDeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }

    /// Opens Wikipedia at the specified location; maps `DeepLinkError` to `OpenWikipediaError`.
    ///
    /// - Parameter location: The location to show in Wikipedia Places.
    /// - Throws: `OpenWikipediaError` when the URL cannot be built or opened.
    func openPlaces(at location: Location) async throws {
        do {
            try await deepLinkService.openPlaces(at: location)
        } catch let error as DeepLinkError {
            switch error {
            case .urlCreationFailed:
                throw OpenWikipediaError.urlCreationFailed
            case .cannotOpenURL:
                throw OpenWikipediaError.cannotOpenURL
            case .appNotInstalled(let appName):
                throw OpenWikipediaError.appNotInstalled(appName: appName)
            }
        }
    }
}

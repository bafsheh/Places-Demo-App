//
//  WikipediaDeepLinkService.swift
//  Places-Demo-App
//
//  Purpose: Builds Wikipedia Places URLs and opens them via the generic deep link service.
//  Dependencies: Location, DeepLinkServiceProtocol.
//  Usage: WikipediaDeepLinkService injected into OpenWikipediaUseCase.
//

import Foundation
import CoreLocation

/// Builds Wikipedia Places deep link URLs (`wikipedia://places?lat=...&long=...&name=...`).
///
/// - SeeAlso: `Location`, `WikipediaDeepLinkService`
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
///
/// - SeeAlso: `WikipediaDeepLinkService`, `OpenWikipediaUseCase`, `Location`
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
///
/// - SeeAlso: `WikipediaPlacesURLBuilder`, `DeepLinkServiceProtocol`, `OpenWikipediaUseCase`
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

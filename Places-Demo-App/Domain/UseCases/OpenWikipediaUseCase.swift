//
//  OpenWikipediaUseCase.swift
//  Places-Demo-App
//
//  Purpose: Use case to open Wikipedia (Places) at a location via deep link; protocol allows test doubles.
//  Dependencies: WikipediaDeepLinkServiceProtocol, Location.
//  Usage: Injected into LocationListViewModel via Dependencies.
//

import Foundation

/// Contract for opening Wikipedia at a location; allows injection of mocks in tests.
///
/// - SeeAlso: `OpenWikipediaUseCase`, `WikipediaDeepLinkServiceProtocol`, `Location`
protocol OpenWikipediaUseCaseProtocol: Sendable {

    /// Opens the Wikipedia app (or fallback) at the given location (e.g. Places tab with coordinates).
    ///
    /// - Parameter location: The location to show in Wikipedia.
    /// - Throws: `DeepLinkError` when the URL cannot be opened (e.g. app not installed).
    func execute(location: Location) async throws
}

/// Use case that opens Wikipedia at a location via a deep link.
///
/// Delegates to `WikipediaDeepLinkServiceProtocol` to build the URL and open it; used when the user taps "Open in Wikipedia" in the list.
///
/// - SeeAlso: `WikipediaDeepLinkServiceProtocol`, `LocationListViewModel`, `Location`
final class OpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {

    private let deepLinkService: WikipediaDeepLinkServiceProtocol

    /// Creates the use case with the given deep link service.
    ///
    /// - Parameter deepLinkService: Service that builds and opens the Wikipedia Places URL (e.g. `WikipediaDeepLinkService` or a test mock).
    init(deepLinkService: WikipediaDeepLinkServiceProtocol) {
        self.deepLinkService = deepLinkService
    }

    /// Opens Wikipedia at the specified location.
    ///
    /// - Parameter location: The location to show (coordinates and optional name).
    /// - Throws: `DeepLinkError` when the URL cannot be opened.
    func execute(location: Location) async throws {
        try await deepLinkService.openPlaces(at: location)
    }
}

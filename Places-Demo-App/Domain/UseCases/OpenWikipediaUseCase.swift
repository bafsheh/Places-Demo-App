//
//  OpenWikipediaUseCase.swift
//  Places-Demo-App
//
//  Purpose: Use case to open Wikipedia (Places) at a location; protocol allows test doubles. Depends only on Domain port.
//  Dependencies: OpenWikipediaAtLocationPort, Location, OpenWikipediaError.
//  Usage: Injected into LocationListViewModel via Dependencies.
//

import Foundation

/// Contract for opening Wikipedia at a location; allows injection of mocks in tests.
protocol OpenWikipediaUseCaseProtocol: Sendable {

    /// Opens the Wikipedia app (or fallback) at the given location (e.g. Places tab with coordinates).
    ///
    /// - Parameter location: The location to show in Wikipedia.
    /// - Throws: `OpenWikipediaError` when the URL cannot be opened (e.g. app not installed).
    func execute(location: Location) async throws
}

/// Use case that opens Wikipedia at a location via a Domain port (e.g. implemented by a deep link adapter).
///
/// Delegates to `OpenWikipediaAtLocationPort`; the Data layer provides an adapter that implements this port. Used when the user taps "Open in Wikipedia" in the list.
final class OpenWikipediaUseCase: OpenWikipediaUseCaseProtocol {

    private let port: OpenWikipediaAtLocationPort

    /// Creates the use case with the given port (implemented by Data layer adapter).
    ///
    /// - Parameter port: Port that opens Wikipedia at a location (e.g. `WikipediaDeepLinkAdapter` or a test mock).
    init(port: OpenWikipediaAtLocationPort) {
        self.port = port
    }

    /// Opens Wikipedia at the specified location.
    ///
    /// - Parameter location: The location to show (coordinates and optional name).
    /// - Throws: `OpenWikipediaError` when the URL cannot be opened.
    func execute(location: Location) async throws {
        try await port.openPlaces(at: location)
    }
}

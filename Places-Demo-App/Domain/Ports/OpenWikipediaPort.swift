//
//  OpenWikipediaPort.swift
//  Places-Demo-App
//
//  Purpose: Domain port (interface) for opening Wikipedia at a location; keeps Domain independent of Data.
//  Dependencies: Foundation, Location (Domain).
//  Usage: Implemented by Data layer adapters (e.g. WikipediaDeepLinkAdapter); used by OpenWikipediaUseCase.
//

import Foundation

/// Port defined by the Domain layer: capability to open Wikipedia (or equivalent) at a given location.
///
/// This is a **port** in Hexagonal/Clean Architecture: the Domain defines the interface it needs;
/// the Data (or Infrastructure) layer provides an **adapter** that implements this interface (e.g. via deep links).
/// Domain must not depend on Data, so this protocol lives in Domain and has no reference to deep links or Data types.
///
protocol OpenWikipediaAtLocationPort: Sendable {

    /// Opens Wikipedia (or fallback) at the specified location (e.g. Places tab with coordinates).
    ///
    /// - Parameter location: The location to show (coordinates and optional name).
    /// - Throws: Domain-defined errors (e.g. `OpenWikipediaError`) when the URL cannot be created or opened.
    func openPlaces(at location: Location) async throws
}

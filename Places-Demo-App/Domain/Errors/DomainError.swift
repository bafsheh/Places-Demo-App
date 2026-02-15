//
//  DomainError.swift
//  Places-Demo-App
//
//  Purpose: Domain-level errors; keeps Domain independent of Data/Infrastructure error types.
//  Dependencies: Foundation.
//  Usage: Thrown by use cases (e.g. OpenWikipediaUseCase); mapped from Data errors in adapters.
//

import Foundation

/// Errors that can occur when opening Wikipedia at a location, as defined by the Domain.
///
/// Use cases throw these types so that Presentation and tests depend only on Domain, not on Data layer errors (e.g. `DeepLinkError`).
/// Adapters in the Data layer catch infrastructure errors and map them to these cases.
///
enum OpenWikipediaError: LocalizedError, Sendable {

    /// URL for the location could not be constructed (e.g. invalid components).
    case urlCreationFailed

    /// System could not open the URL (generic failure).
    case cannotOpenURL

    /// Target app (e.g. Wikipedia) is not installed; associated value is the app name if known.
    case appNotInstalled(appName: String?)

    var errorDescription: String? {
        switch self {
        case .urlCreationFailed:
            return String(localized: "error.urlCreationFailed")
        case .cannotOpenURL:
            return String(localized: "error.cannotOpenURL")
        case .appNotInstalled(let name):
            return name.map { "\($0) is not installed" } ?? String(localized: "error.appNotInstalled")
        }
    }
}

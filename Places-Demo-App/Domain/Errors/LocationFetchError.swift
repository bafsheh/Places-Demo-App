import Foundation

/// Errors that can occur when fetching locations, as defined by the Domain.
///
/// Use cases throw these types so that Presentation depends only on Domain, not on Data layer errors (e.g. `NetworkError`).
/// The Data layer (e.g. `LocationRepository`) catches infrastructure errors and maps them to these cases.
///
enum LocationFetchError: LocalizedError, Sendable {

    /// Network or connectivity failure (e.g. no data, request failed, HTTP error).
    case networkUnavailable

    /// Received data could not be parsed or URL was invalid.
    case invalidData

    /// Unexpected or unknown failure.
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return String(localized: "error.locationFetch.networkUnavailable")
        case .invalidData:
            return String(localized: "error.locationFetch.invalidData")
        case .unknown:
            return String(localized: "error.locationFetch.unknown")
        }
    }
}

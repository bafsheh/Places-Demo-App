//
//  NetworkError.swift
//  Places-Demo-App
//
//  Purpose: Errors for network layer (URL, HTTP, decoding, transport).
//  Dependencies: None.
//  Usage: Thrown by NetworkService and consumed by callers (e.g. ViewModel).
//

import Foundation

/// Errors that can occur during network operations.
///
/// Uses `String` for decoding/network cases to remain `Sendable` under Swift 6 strict concurrency. Conforms to `LocalizedError` for user-facing messages.
///
/// - SeeAlso: `NetworkService`, `RemoteDataSource`
enum NetworkError: LocalizedError, Sendable {

    /// URL construction failed (e.g. invalid base URL + path).
    case invalidURL

    /// No data received in the response.
    case noData

    /// JSON decoding failed; associated string is the underlying error description.
    case decodingError(String)

    /// HTTP response had a non-success status code.
    case httpError(statusCode: Int)

    /// Transport or low-level network failure; associated string describes the error.
    case networkFailure(String)

    /// Unexpected or unknown error (e.g. response was not HTTPURLResponse).
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let message):
            return message.isEmpty ? "Decoding error" : message
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .networkFailure(let message):
            return message.isEmpty ? "Network failure" : message
        case .unknown:
            return "Unknown error"
        }
    }
}

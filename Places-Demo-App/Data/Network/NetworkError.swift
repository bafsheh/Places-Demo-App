//
//  NetworkError.swift
//  Places-Demo-App
//

import Foundation

/// Errors that can occur during network operations.
/// Uses `String` for decoding/network cases to remain `Sendable` under Swift 6 strict concurrency.
enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingError(String)
    case httpError(statusCode: Int)
    case networkFailure(String)
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

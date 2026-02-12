//
//  NetworkConfiguration.swift
//  Places-Demo-App
//
//  Purpose: Holds base URL, headers, and timeout for network requests.
//  Dependencies: AppConfiguration (for default base URL).
//  Usage: Passed to NetworkService and endpoints when building URLRequest.
//

import Foundation

/// Configuration for network requests: base URL, headers, and timeout.
///
/// Used by `NetworkService` and by endpoints when building `URLRequest`. The static `default` uses `AppConfiguration.apiBaseURL`.
///
struct NetworkConfiguration: Sendable {

    /// Base URL for requests (e.g. `"https://api.example.com"`); no trailing slash.
    let baseURL: String

    /// HTTP headers applied to every request (e.g. Content-Type, Accept).
    let headers: [String: String]

    /// Request timeout in seconds.
    let timeout: TimeInterval

    /// Creates a network configuration.
    ///
    /// - Parameters:
    ///   - baseURL: Base URL string.
    ///   - headers: Optional headers; defaults to empty.
    ///   - timeout: Timeout in seconds; defaults to 30.
    init(
        baseURL: String,
        headers: [String: String] = [:],
        timeout: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.timeout = timeout
    }

    /// Default configuration for the locations API.
    ///
    /// Base URL comes from `AppConfiguration.apiBaseURL` (Info.plist or environment); sets JSON content type and accept headers.
    static var `default`: NetworkConfiguration {
        NetworkConfiguration(
            baseURL: AppConfiguration.apiBaseURL,
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        )
    }
}

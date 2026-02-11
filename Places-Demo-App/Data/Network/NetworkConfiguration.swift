//
//  NetworkConfiguration.swift
//  Places-Demo-App
//

import Foundation

/// Configuration for network requests: base URL, headers, and timeout.
struct NetworkConfiguration: Sendable {

    /// Base URL for requests (e.g. `"https://api.example.com"`).
    let baseURL: String

    /// HTTP headers applied to every request.
    let headers: [String: String]

    /// Request timeout in seconds.
    let timeout: TimeInterval

    /// Creates a network configuration.
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

    /// Default configuration for the locations API. Base URL comes from AppConfiguration (Info.plist or environment).
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

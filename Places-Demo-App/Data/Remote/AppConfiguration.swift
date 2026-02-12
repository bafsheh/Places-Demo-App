//
//  AppConfiguration.swift
//  Places-Demo-App
//
//  Purpose: Reads app-wide config (e.g. API base URL) from Info.plist or environment.
//  Dependencies: Foundation (Bundle, ProcessInfo).
//  Usage: Used by NetworkConfiguration.default for API base URL.
//

import Foundation

/// App-wide configuration read from Info.plist or environment.
///
/// Allows staging/production and feature toggles without code changes. Falls back to defaults when keys are missing. Used by `NetworkConfiguration.default` for the API base URL.
///
/// - SeeAlso: `NetworkConfiguration`
enum AppConfiguration: Sendable {

    private static let defaultBaseURL = "https://raw.githubusercontent.com"

    /// API base URL for network requests.
    ///
    /// Resolution order: Info.plist key `APIBaseURL`, then process environment `API_BASE_URL`, then built-in default (e.g. raw GitHub content base).
    static var apiBaseURL: String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String, !url.isEmpty {
            return url
        }
        if let url = ProcessInfo.processInfo.environment["API_BASE_URL"], !url.isEmpty {
            return url
        }
        return defaultBaseURL
    }
}

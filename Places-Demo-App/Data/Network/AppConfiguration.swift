//
//  AppConfiguration.swift
//  Places-Demo-App
//

import Foundation

/// App-wide configuration read from Info.plist or environment. Allows staging/production
/// and feature toggles without code changes. Falls back to defaults when keys are missing.
enum AppConfiguration: Sendable {

    private static let defaultBaseURL = "https://raw.githubusercontent.com"

    /// API base URL for network requests. Reads from Info.plist key `APIBaseURL`, then
    /// from process environment `API_BASE_URL`, then falls back to default.
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

//
//  Accessibility.swift
//  Places-Demo-App
//
//  Purpose: Stable accessibility identifiers for UI tests and optional typealias for localized a11y strings.
//  Dependencies: None.
//  Usage: Use AccessibilityID.xxx.rawValue for accessibilityIdentifier; Accessibility.xxx for labels/hints.
//

import Foundation

/// Stable string constants for UI testing and accessibility identifiers.
///
/// Use with `.accessibilityIdentifier(AccessibilityID.xxx.rawValue)` so UI tests can find elements. For localized labels and hints use `LocalizationHelper.Accessibility` or the typealias `Accessibility`.
///
enum AccessibilityID: String {

    case addLocationForm
    case addLocationNameField
    case addLocationLatitudeField
    case addLocationLongitudeField
    case addLocationCancelButton
    case addLocationAddButton

    case placesList
    case placesAddButton
    case placesOpenInWikipediaAlertDismissButton

    case errorViewRetryButton
    case loadingView

    /// Prefix for location row identifiers; combine with location id for unique row ids (e.g. `locationRow(id: location.id.uuidString)`).
    static let locationRowPrefix = "locationRow-"

    /// Builds a stable accessibility identifier for a location list row.
    ///
    /// - Parameter id: Unique string for the row (e.g. `location.id.uuidString`).
    /// - Returns: String like `"locationRow-<id>"` for use with `accessibilityIdentifier`.
    static func locationRow(id: String) -> String {
        locationRowPrefix + id
    }
}

/// Shortcut for `LocalizationHelper.Accessibility` so views can use `Accessibility.AddLocation.latitudeField` etc. for labels and hints.
typealias Accessibility = LocalizationHelper.Accessibility

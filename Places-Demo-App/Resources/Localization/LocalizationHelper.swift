//
//  LocalizationHelper.swift
//  Places-Demo-App
//
//  Purpose: Central namespace for localized strings; use String Catalog (Localizable.xcstrings) for translations.
//  Dependencies: Foundation (String(localized:)).
//  Usage: LocalizationHelper.Common.xxx, LocalizationHelper.Places.xxx (see extensions).
//

import Foundation

/// Central namespace for all localized copy; uses the String Catalog (Localizable.xcstrings) for translations.
///
/// Structure is grouped by screen/domain (Common, Places, AddLocation, Location, Accessibility) for discoverability and scalability. Extensions add nested enums (e.g. `LocalizationHelper.Places`).
///
enum LocalizationHelper {

    /// Strings shared across screens (loading, error, retry, accessibility hints).
    enum Common {
        static var loading: String { String(localized: "common.loading") }
        static var error: String { String(localized: "common.error") }
        static var retry: String { String(localized: "common.retry") }
        static var accessibilityRetryHint: String { String(localized: "common.accessibilityRetryHint") }
        static var networkError: String { String(localized: "common.networkError") }
        static var genericError: String { String(localized: "common.genericError") }
    }
}

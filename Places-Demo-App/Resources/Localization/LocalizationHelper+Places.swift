//
//  LocalizationHelper+Places.swift
//  Places-Demo-App
//
//  Purpose: Localized strings for the places/list screen.
//  Dependencies: LocalizationHelper, String Catalog.
//  Usage: LocalizationHelper.Places.title, .add, .loadingLocations.
//

import Foundation

/// Localized strings for the places/list screen (title, add button, loading message).
extension LocalizationHelper {

    enum Places {
        static var title: String { String(localized: "places.title") }
        static var add: String { String(localized: "places.add") }
        static var loadingLocations: String { String(localized: "places.loadingLocations") }
        static var openInWikipediaAlertTitle: String { String(localized: "places.openInWikipediaAlertTitle") }
        static var openInWikipediaAlertDismiss: String { String(localized: "places.openInWikipediaAlertDismiss") }
    }
}

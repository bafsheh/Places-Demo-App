//
//  LocalizationHelper+Location.swift
//  Places-Demo-App
//
//  Purpose: Localized strings for location-related UI (e.g. unnamed location fallback).
//  Dependencies: LocalizationHelper, String Catalog.
//  Usage: LocalizationHelper.Location.unnamedLocation.
//

import Foundation

/// Localized strings for location-related UI (e.g. fallback when location has no name).
extension LocalizationHelper {

    enum Location {
        /// Shown when a location has no name (e.g. in list row).
        static var unnamedLocation: String { String(localized: "location.unnamedLocation") }
    }
}

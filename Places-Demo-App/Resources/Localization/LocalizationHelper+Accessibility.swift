//
//  LocalizationHelper+Accessibility.swift
//  Places-Demo-App
//
//  Purpose: Localized accessibility labels and hints for VoiceOver and testing.
//  Dependencies: LocalizationHelper, String Catalog.
//  Usage: LocalizationHelper.Accessibility.AddLocation.xxx, .Places.xxx; typealias Accessibility for shortcuts.
//

import Foundation

/// Localized accessibility labels and hints for VoiceOver and testing; use with accessibilityLabel/accessibilityHint. For stable UI-test identifiers use `AccessibilityID` in Accessibility.swift.
extension LocalizationHelper {

    enum Accessibility {
        /// Hint for elements that open content in Wikipedia (e.g. location row).
        static var opensInWikipedia: String { String(localized: "accessibility.opensInWikipedia") }

        /// Labels and hints for the add-location form and its fields/buttons.
        enum AddLocation {
            static var formLabel: String { String(localized: "accessibility.addLocation.formLabel") }
            static var nameField: String { String(localized: "accessibility.addLocation.nameField") }
            static var nameHint: String { String(localized: "accessibility.addLocation.nameHint") }
            static var latitudeField: String { String(localized: "accessibility.addLocation.latitudeField") }
            static var latitudeHint: String { String(localized: "accessibility.addLocation.latitudeHint") }
            static var longitudeField: String { String(localized: "accessibility.addLocation.longitudeField") }
            static var longitudeHint: String { String(localized: "accessibility.addLocation.longitudeHint") }
            static var cancelButtonHint: String { String(localized: "accessibility.addLocation.cancelButtonHint") }
            static var addButtonHint: String { String(localized: "accessibility.addLocation.addButtonHint") }
        }

        /// Labels and hints for the places list screen.
        enum Places {
            static var listLabel: String { String(localized: "accessibility.places.listLabel") }
            static var addButtonHint: String { String(localized: "accessibility.places.addButtonHint") }
        }
    }
}

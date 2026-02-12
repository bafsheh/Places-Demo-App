import Foundation

extension LocalizationHelper {

    /// Localized accessibility labels and hints. Use with accessibilityLabel/accessibilityHint.
    /// For stable UI-test identifiers use AccessibilityID in Accessibility.swift.
    enum Accessibility {

        static var opensInWikipedia: String { String(localized: "accessibility.opensInWikipedia") }

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

        enum Places {
            static var listLabel: String { String(localized: "accessibility.places.listLabel") }
            static var addButtonHint: String { String(localized: "accessibility.places.addButtonHint") }
        }
    }
}

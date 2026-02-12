import Foundation

/// Centralized access to all localized strings. Use the String Catalog (Localizable.xcstrings) for translations.
/// Structure is grouped by screen/domain for discoverability and scalability.
enum LocalizedStrings {

    enum AddLocation {
        static var title: String { String(localized: "addLocation.title") }
        static var sectionName: String { String(localized: "addLocation.sectionName") }
        static var namePlaceholder: String { String(localized: "addLocation.namePlaceholder") }
        static var sectionCoordinates: String { String(localized: "addLocation.sectionCoordinates") }
        static var latLongFooter: String { String(localized: "addLocation.latLongFooter") }
        static var cancel: String { String(localized: "addLocation.cancel") }
        static var add: String { String(localized: "addLocation.add") }
        static var alertInvalidTitle: String { String(localized: "addLocation.alertInvalidTitle") }
        static var alertOk: String { String(localized: "addLocation.alertOk") }
        static var alertInvalidMessage: String { String(localized: "addLocation.alertInvalidMessage") }
        static var textFieldLatitude: String { String(localized: "addLocation.textFieldLatitude") }
        static var textFieldLongitude: String { String(localized: "addLocation.textFieldLongitude") }
    }

    enum Places {
        static var title: String { String(localized: "places.title") }
        static var add: String { String(localized: "places.add") }
        static var loadingLocations: String { String(localized: "places.loadingLocations") }
    }

    enum Common {
        static var loading: String { String(localized: "common.loading") }
        static var error: String { String(localized: "common.error") }
        static var retry: String { String(localized: "common.retry") }
        static var accessibilityRetryHint: String { String(localized: "common.accessibilityRetryHint") }
    }

    enum Accessibility {
        static var opensInWikipedia: String { String(localized: "accessibility.opensInWikipedia") }
    }

    enum Location {
        static var unnamedLocation: String { String(localized: "location.unnamedLocation") }
    }
}

//
//  LocalizationHelper+AddLocation.swift
//  Places-Demo-App
//
//  Purpose: Localized strings for the add-location sheet.
//  Dependencies: LocalizationHelper, String Catalog.
//  Usage: LocalizationHelper.AddLocation.title, .namePlaceholder, .cancel, etc.
//

import Foundation

/// Localized strings for the add-location sheet (title, section headers, placeholders, buttons, alert).
extension LocalizationHelper {

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
}

import Foundation

/// Stable string constants for UI testing. Use with `.accessibilityIdentifier(AccessibilityID.xxx.rawValue)`.
/// For localized labels and hints use LocalizationHelper.Accessibility (or typealias Accessibility).
enum AccessibilityID: String {

    case addLocationForm
    case addLocationNameField
    case addLocationLatitudeField
    case addLocationLongitudeField
    case addLocationCancelButton
    case addLocationAddButton

    case placesList
    case placesAddButton

    case errorViewRetryButton
    case loadingView

    /// Use for list rows: e.g. `AccessibilityID.locationRowPrefix.rawValue + location.id.uuidString`
    static let locationRowPrefix = "locationRow-"

    static func locationRow(id: String) -> String {
        locationRowPrefix + id
    }
}

/// Shortcut for LocalizationHelper.Accessibility so views can use Accessibility.AddLocation.latitudeField etc.
typealias Accessibility = LocalizationHelper.Accessibility

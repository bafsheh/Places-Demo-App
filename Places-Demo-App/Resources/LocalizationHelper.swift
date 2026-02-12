import Foundation

/// Central helper for all localized copy. Use the String Catalog (Localizable.xcstrings) for translations.
/// Structure is grouped by screen/domain for discoverability and scalability.
enum LocalizationHelper {

    enum Common {
        static var loading: String { String(localized: "common.loading") }
        static var error: String { String(localized: "common.error") }
        static var retry: String { String(localized: "common.retry") }
        static var accessibilityRetryHint: String { String(localized: "common.accessibilityRetryHint") }
    }
}
